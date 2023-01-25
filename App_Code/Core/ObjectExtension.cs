using System.Data;
using Newtonsoft.Json;

/// <summary>
/// Summary description for ObjectExtension
/// </summary>
/// 
namespace Core
{


    public static class ObjectExtension
    {
        public static string ToJson(this DataTable dt)
        {
            return JsonConvert.SerializeObject(dt);
        }
    }

}