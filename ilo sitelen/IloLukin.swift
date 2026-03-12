//
//  IloLukin.swift
//  ilo sitelen
//
//  Created by koteczek on 3/11/26.
//

import SwiftUI
import PencilKit
import Vision
import Combine
import CoreML

class DrawingProcessor: ObservableObject {
    @Published var debugImage: UIImage? = nil
    @Published var predictions: [VNClassificationObservation] = []
    
    let drawingSubject = PassthroughSubject<PKDrawing, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    lazy var visionModel: VNCoreMLModel? = {
        do {
            let config = MLModelConfiguration()
            let model = try SitelenPonaModel(configuration: config)
            return try VNCoreMLModel(for: model.model)
        } catch {
            return nil
        }
    }()
    
    init() {
        drawingSubject
            .debounce(for: .milliseconds(400), scheduler: RunLoop.main)
            .sink { [weak self] drawing in
                self?.process(drawing: drawing)
            }
            .store(in: &cancellables)
    }
    
    func process(drawing: PKDrawing) {
        guard !drawing.strokes.isEmpty else {
            DispatchQueue.main.async {
                self.debugImage = nil
                self.predictions = []
            }
            return
        }
        
        let bounds = drawing.bounds
        guard bounds.width > 0 && bounds.height > 0 else { return }
        
        let maxDim: CGFloat = 24.0
        let scale = min(maxDim / bounds.width, maxDim / bounds.height)
        let newSize = CGSize(width: bounds.width * scale, height: bounds.height * scale)
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 28, height: 28))
        let processedImage = renderer.image { ctx in
            UIColor.black.setFill()
            ctx.fill(CGRect(x: 0, y: 0, width: 28, height: 28))
            
            let drawnImage = drawing.image(from: bounds, scale: 1.0)
            let xOffset = (28.0 - newSize.width) / 2.0
            let yOffset = (28.0 - newSize.height) / 2.0
            let rect = CGRect(x: xOffset, y: yOffset, width: newSize.width, height: newSize.height)
            
            if let cgImage = drawnImage.cgImage {
                ctx.cgContext.saveGState()
                ctx.cgContext.translateBy(x: 0, y: 28)
                ctx.cgContext.scaleBy(x: 1.0, y: -1.0)
                let flippedRect = CGRect(x: rect.origin.x, y: 28 - rect.origin.y - rect.height, width: rect.width, height: rect.height)
                
                ctx.cgContext.clip(to: flippedRect, mask: cgImage)
                UIColor.white.setFill()
                ctx.cgContext.fill(flippedRect)
                ctx.cgContext.restoreGState()
            }
        }
        
        DispatchQueue.main.async {
            self.debugImage = processedImage
        }
        
        guard let cgImage = processedImage.cgImage, let visionModel = visionModel else { return }
        
        let request = VNCoreMLRequest(model: visionModel) { [weak self] request, error in
            if let results = request.results as? [VNClassificationObservation] {
                DispatchQueue.main.async {
                    self?.predictions = results
                }
            }
        }
        
        request.imageCropAndScaleOption = .scaleFit
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
            }
        }
    }
}

struct DrawingPad: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    var onDrawingChanged: () -> Void

    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.drawingPolicy = .anyInput
        canvasView.tool = PKInkingTool(.pen, color: .label, width: 15)
        canvasView.backgroundColor = UIColor.secondarySystemBackground
        canvasView.delegate = context.coordinator
        return canvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: DrawingPad
        init(_ parent: DrawingPad) { self.parent = parent }
        
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            parent.onDrawingChanged()
        }
    }
}
