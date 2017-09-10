//
//  Options.swift
//
//  Created by Omer Karisman on 2017/08/29.
//

import UIKit
import AVFoundation

extension SceneKitVideoRecorder {
  public struct Options {
    public var timeScale: Int32
    public var videoSize: CGSize
    public var fps: Int
    public var outputUrl: URL
    public var fileType: String
    public var codec: String
    public var deleteFileIfExists: Bool
    public var useMicrophone: Bool
    
    public static var `default`: Options {
      return Options(timeScale: 1000,
                     videoSize: CGSize(width: 1280, height: 720),
                     fps: 60,
                     outputUrl: URL(fileURLWithPath: NSHomeDirectory() + "/Documents/output.mp4"),
                     fileType: AVFileType.mp4.rawValue,
                     codec: AVVideoCodecType.h264.rawValue,
                     deleteFileIfExists: true,
                     useMicrophone: false)
    }
    
    var assetWriterVideoInputSettings: [String : Any] {
      return [
        AVVideoCodecKey: codec,
        AVVideoWidthKey: videoSize.width,
        AVVideoHeightKey: videoSize.height
      ]
    }
    
    var assetWriterAudioInputSettings: [String : Any] {
      return [:]
    }
    
    var sourcePixelBufferAttributes: [String : Any] {
      return [
        kCVPixelBufferPixelFormatTypeKey as String: NSNumber(value: kCVPixelFormatType_32BGRA),
        kCVPixelBufferWidthKey as String: videoSize.width,
        kCVPixelBufferHeightKey as String: videoSize.height,
      ]
    }
  }
}

