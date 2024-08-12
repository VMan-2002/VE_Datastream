package;

@:cppFileCode('#include <string>\n#include <windows.h>\nusing std::min;\nusing std::max;\n#include <gdiplus.h>\n#include <wingdi.h>\n\n#pragma comment(lib, "Gdiplus.lib")\n#pragma comment(lib, "Gdi32.lib")')
class ScriptingDatastreamCpp {
    static var screenshotResult:Bool = false;
    static var screenshotFileResult:Int = 6;
    public static var screenshotFilePath:String = "";
    public static var screenshotFilePathLength:Int = 0;
    @:functionCode('
        auto GetEncoderClsid = [](const WCHAR* format, CLSID* pClsid)
        {
            UINT  num = 0;          // number of image encoders
            UINT  size = 0;         // size of the image encoder array in bytes

            Gdiplus::GetImageEncodersSize(&num, &size);
            if(size == 0)
                return -1;  // Failure

            Gdiplus::ImageCodecInfo* pImageCodecInfo = (Gdiplus::ImageCodecInfo*)(malloc(size));
            if(pImageCodecInfo == NULL)
                return -1;  // Failure

            GetImageEncoders(num, size, pImageCodecInfo);

            for(INT j = 0; j < num; ++j)
            {
                if(wcscmp(pImageCodecInfo[j].MimeType, format) == 0)
                {
                    *pClsid = pImageCodecInfo[j].Clsid;
                    free(pImageCodecInfo);
                    return j;  // Success
                }
            }

            free(pImageCodecInfo);
            return -1;  // Failure
        };
        
        auto screenshot = [&GetEncoderClsid](POINT a, POINT b)
        {
            int w = b.x - a.x;
            int h = b.y - a.y;

            if(w <= 0) return;
            if(h <= 0) return;

            HDC     hScreen = GetDC(HWND_DESKTOP);
            HDC     hDc = CreateCompatibleDC(hScreen);
            HBITMAP hBitmap = CreateCompatibleBitmap(hScreen, w, h);
            HGDIOBJ old_obj = SelectObject(hDc, hBitmap);
            BitBlt(hDc, 0, 0, w, h, hScreen, a.x, a.y, SRCCOPY);

            if (hBitmap == NULL) {
                screenshotResult = false;
            } else {
                screenshotResult = true;
            }

            Gdiplus::Bitmap bitmap(hBitmap, NULL);
            CLSID clsid;

            GetEncoderClsid(L"image/png", &clsid);

            //GDI+ expects Unicode filenames
            std::wstring wideusername;
            for(int i = 0; i < screenshotFilePath.length; ++i) {
                wideusername += wchar_t( screenshotFilePath[i] );
            }

            const wchar_t* your_result = wideusername.c_str();
            screenshotFileResult = bitmap.Save(your_result, &clsid);

            SelectObject(hDc, old_obj);
            DeleteDC(hDc);
            ReleaseDC(HWND_DESKTOP, hScreen);
            DeleteObject(hBitmap);
        };
        
        auto bmain = [&screenshot](String name, INT width, INT height)
        {
            Gdiplus::GdiplusStartupInput gdiplusStartupInput;
            ULONG_PTR gdiplusToken;
            Gdiplus::GdiplusStartup(&gdiplusToken, &gdiplusStartupInput, NULL);

            RECT      rc;
            GetClientRect(GetDesktopWindow(), &rc);
            POINT a{ 0, 0 };
            POINT b{ width, height };

            screenshot(a, b);

            Gdiplus::GdiplusShutdown(gdiplusToken);

            return 0;
        };
        bmain(filename, width, height);
    ')
    public static function screenCapture(?filename:String = "", width:Int, height:Int) {
        trace("|| Screenshot Result || "+screenshotResult);
        trace("|| Screenshot File Result || "+screenshotFileResult);
    }
}