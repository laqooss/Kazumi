// This file is a part of media_kit
// (https://github.com/media-kit/media-kit).
//
// Copyright © 2021 & onwards, Hitesh Kumar Saini <saini123hitesh@gmail.com>.
// All rights reserved.
// Use of this source code is governed by MIT license that can be found in the
// LICENSE file.

#ifndef FULLSCREEN_UTILS_H_
#define FULLSCREEN_UTILS_H_

#include <cstdint>

#include <Windows.h>

class FullscreenUtils {
 public:
  static void EnterNativeFullscreen(HWND window);

  static void ExitNativeFullscreen(HWND window);

 private:
  static constexpr auto kFlutterViewWindowClassName = L"FLUTTERVIEW";

  static bool fullscreen_;
  static RECT rect_before_fullscreen_;
};

#endif  // FULLSCREEN_UTILS_H_
