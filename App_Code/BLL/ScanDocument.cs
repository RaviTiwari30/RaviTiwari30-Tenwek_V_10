using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
//using WIA;

/// <summary>
/// Summary description for Scanner
/// </summary>
public class ScanDocument
{
    
	public ScanDocument()
	{
		//
		// TODO: Add constructor logic here
		//
	}

	public List<Scanner> GetScanners()
	{
		//var deviceManager = new DeviceManager();
		List<Scanner> scannerList = new List<Scanner>();
        //for (int i = 1; i <= deviceManager.DeviceInfos.Count; i++)
        //{
        //    Scanner scanner = new Scanner(); 
        //    scanner.Name= deviceManager.DeviceInfos[i].Properties["Name"].get_Value().ToString();
        //    scanner.DeviecId= deviceManager.DeviceInfos[i].DeviceID;
        //    scannerList.Add(scanner);
        //}
		return scannerList;
	}


	//public string ScanDoc(string deviceID, string fileName,string path)
	//{
	//    try
	//    {
	//        var scannerIndex = -1;
	//        var scanner = GetScanners();
	//        for (int i = 0; i < scanner.Count; i++)
	//        {
	//            if (scanner[i].DeviecId==deviceID)
	//            {
	//                scannerIndex = i + 1;
	//                break;
	//            }
	//        }






	//        CommonDialogClass commonDialogClass = new CommonDialogClass();
	//        Device scannerDevice = commonDialogClass.ShowSelectDevice(WiaDeviceType.ScannerDeviceType, false, false);
	//        if (scannerDevice != null)
	//        {

	//            Item scannnerItem = scannerDevice.Items[1];
	//            //AdjustScannerSettings(scannnerItem, (int)nudRes.Value, 0, 0, (int)nudWidth.Value, (int)nudHeight.Value, 0, 0, cmbCMIndex);
	//            AdjustScannerSettings(scannnerItem, 100, 0, 0, 800, 1100, 0, 0, 1);
	//            object scanResult = commonDialogClass.ShowTransfer(scannnerItem, WIA.FormatID.wiaFormatJPEG, false);
	//            if (scanResult != null)
	//            {
	//                ImageFile image = (ImageFile)scanResult;
	//                fileName =  path + "\\" + fileName + ".jpeg";
	//                SaveImage(image, fileName);
					
	//            }
	//        }
	//        return "Ok";
	//    }
	//    catch (Exception err)
	//    {
	//        ClassLog classLog = new ClassLog();
	//        classLog.errLog(err);
	//        return err.Message;
	//    }

	//}

	public string ScanDoc(string deviceID, string fileName, string path)
	{
		try
		{
			//DeviceManager deviceManager = new DeviceManager();
			//DeviceInfo firstScannerAvailable = null;
            //for (int i = 1; i <= deviceManager.DeviceInfos.Count; i++)
            //{
            //    // Skip the device if it's not a scanner
            //    if (deviceManager.DeviceInfos[i].Type != WiaDeviceType.ScannerDeviceType)
            //    {
            //        continue;
            //    }

            //    if (deviceManager.DeviceInfos[i].DeviceID == deviceID)
            //    {
            //        firstScannerAvailable = deviceManager.DeviceInfos[i];
            //        break;
            //    }

            //}

            //var scannerDevice = firstScannerAvailable.Connect();
            //CommonDialogClass commonDialogClass = new CommonDialogClass();
            //// Device scannerDevice = commonDialogClass.ShowSelectDevice(WiaDeviceType.ScannerDeviceType, true, false);

            //if (scannerDevice != null)
            //{
            //    Item scannnerItem = scannerDevice.Items[1];
            //    AdjustScannerSettings(scannnerItem, 100, 0, 0, 800, 1100, 0, 0, 1);
            //    object scanResult = commonDialogClass.ShowTransfer(scannnerItem, WIA.FormatID.wiaFormatJPEG, false);
            //    if (scanResult != null)
            //    {
            //        ImageFile image = (ImageFile)scanResult;
            //        fileName = path + "\\" + fileName + ".jpeg";
            //        SaveImage(image, fileName);

            //    }
            //}
			return "ok";
		}
		catch (Exception err)
		{
			ClassLog classLog = new ClassLog();
			classLog.errLog(err);
			return err.Message;
		}

	}


    //public static void SaveImage(ImageFile image, string fileName)
    //{
    //    ImageProcess imgProcess = new ImageProcess();
    //    object convertFilter = "Convert";
    //    string convertFilterID = imgProcess.FilterInfos.get_Item(ref convertFilter).FilterID;
    //    imgProcess.Filters.Add(convertFilterID, 0);
    //    SetWIAProperty(imgProcess.Filters[imgProcess.Filters.Count].Properties, "FormatID", WIA.FormatID.wiaFormatJPEG);
    //    image = imgProcess.Apply(image);
    //    if (File.Exists(fileName))
    //        File.Delete(fileName);

    //    image.SaveFile(fileName);
    //}

    //private static void SetWIAProperty(IProperties properties, object propName, object propValue)
    //{
    //    Property prop = properties.get_Item(ref propName);
    //    prop.set_Value(ref propValue);
    //}



    //private static void AdjustScannerSettings(IItem scannnerItem, int scanResolutionDPI, int scanStartLeftPixel, int scanStartTopPixel,
    //            int scanWidthPixels, int scanHeightPixels, int brightnessPercents, int contrastPercents, int colorMode)
    //{
    //    const string WIA_SCAN_COLOR_MODE = "6146";
    //    const string WIA_HORIZONTAL_SCAN_RESOLUTION_DPI = "6147";
    //    const string WIA_VERTICAL_SCAN_RESOLUTION_DPI = "6148";
    //    const string WIA_HORIZONTAL_SCAN_START_PIXEL = "6149";
    //    const string WIA_VERTICAL_SCAN_START_PIXEL = "6150";
    //    const string WIA_HORIZONTAL_SCAN_SIZE_PIXELS = "6151";
    //    const string WIA_VERTICAL_SCAN_SIZE_PIXELS = "6152";
    //    const string WIA_SCAN_BRIGHTNESS_PERCENTS = "6154";
    //    const string WIA_SCAN_CONTRAST_PERCENTS = "6155";
    //    SetWIAProperty(scannnerItem.Properties, WIA_HORIZONTAL_SCAN_RESOLUTION_DPI, scanResolutionDPI);
    //    SetWIAProperty(scannnerItem.Properties, WIA_VERTICAL_SCAN_RESOLUTION_DPI, scanResolutionDPI);
    //    SetWIAProperty(scannnerItem.Properties, WIA_HORIZONTAL_SCAN_START_PIXEL, scanStartLeftPixel);
    //    SetWIAProperty(scannnerItem.Properties, WIA_VERTICAL_SCAN_START_PIXEL, scanStartTopPixel);
    //    SetWIAProperty(scannnerItem.Properties, WIA_HORIZONTAL_SCAN_SIZE_PIXELS, scanWidthPixels);
    //    SetWIAProperty(scannnerItem.Properties, WIA_VERTICAL_SCAN_SIZE_PIXELS, scanHeightPixels);
    //    SetWIAProperty(scannnerItem.Properties, WIA_SCAN_BRIGHTNESS_PERCENTS, brightnessPercents);
    //    SetWIAProperty(scannnerItem.Properties, WIA_SCAN_CONTRAST_PERCENTS, contrastPercents);
    //    SetWIAProperty(scannnerItem.Properties, WIA_SCAN_COLOR_MODE, colorMode);



    //}
	public class Scanner
	{
		public string Name { get; set; }
		public string DeviecId { get; set; }    
	}

	



}