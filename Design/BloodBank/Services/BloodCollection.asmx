<%@ WebService Language="C#" Class="BloodCollection" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data;
using System.Collections.Generic;
using System.Web.Script;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Text;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.ComponentModel.ToolboxItem(false)]
[ScriptService]
public class BloodCollection  : System.Web.Services.WebService {
    public BloodCollection()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }
    public enum makejson
    {
        e_without_square_brackets,
        e_with_square_brackets
    }
    [WebMethod]
    public string HelloWorld() {
        return "Hello World";
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string Collection(string VisitorID, string Name,string BloodGroup,string EntryDate1,string EntryDate2)
    {
        StringBuilder sb = new StringBuilder();
        

        sb.Append("SELECT bv.Visitor_ID,bvh.Visit_ID,bvh.isFit,bvh.BagType,bvh.Quantity,bv.Name,bv.dtBirth,bv.Gender,DATE_FORMAT(bv.dtEntry,'%d -%b-%y')dtEntry,bm.BloodGroup FROM bb_visitors bv  ");
        sb.Append(" INNER JOIN bb_visitors_history bvh ON bv.Visitor_ID=bvh.Visitor_ID LEFT OUTER JOIN bb_bloodgroup_master bm ON bm.Id=bv.BloodGroup_Id ");
        sb.Append(" WHERE isFit=1  ");
        if (VisitorID != "")
        {
            sb.Append("and bv.Visitor_ID='" + VisitorID + "'");
        }
        if (Name != "")
        {
            sb.Append(" and bv.Name like '" + Name + "%'");
        }
        if (BloodGroup != "NA")
        {
            sb.Append(" and bm.BloodGroup='" + BloodGroup + "'");
        }
        if (EntryDate1 != "")
        {
            sb.Append(" and date(bv.dtentry)>='" + Util.GetDateTime(EntryDate1).ToString("yyyy-MM-dd") + "'   ");
        }
        if (EntryDate2 != "")
        {
            sb.Append("     and date(bv.dtentry) <='" + Util.GetDateTime(EntryDate2).ToString("yyyy-MM-dd") + "'   ");
        }
        
        
        DataTable dtItem = StockReports.GetDataTable(sb.ToString());
        return makejsonoftable(dtItem, makejson.e_without_square_brackets);
    }
    public string makejsonoftable(DataTable table, makejson e)
    {
        StringBuilder sb = new StringBuilder();
        foreach (DataRow dr in table.Rows)
        {
            if (sb.Length != 0)
                sb.Append(",");
            sb.Append("{");
            StringBuilder sb2 = new StringBuilder();
            foreach (DataColumn col in table.Columns)
            {
                string fieldname = col.ColumnName;
                string fieldvalue = dr[fieldname].ToString();
                if (sb2.Length != 0)
                    sb2.Append(",");
                sb2.Append(string.Format("{0}:\"{1}\"", fieldname, fieldvalue));


            }
            sb.Append(sb2.ToString());
            sb.Append("}");


        }
        if (e == makejson.e_with_square_brackets)
        {
            sb.Insert(0, "[");
            sb.Append("]");
        }
        return sb.ToString();


    }
}

