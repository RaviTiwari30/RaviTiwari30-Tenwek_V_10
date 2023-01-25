using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI.HtmlControls;

public partial class Design_Kitchen_CanteenIssue : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindTitle();
            All_LoadData.bindDoctor(ddlDoctor);
            ddlDoctor.SelectedValue = Resources.Resource.DoctorID_Self;
            lblDeptLedgerNo.Text = Session["DeptLedgerNo"].ToString();
        }

        string cmd = Util.GetString(Request.QueryString["cmd"]);
        string rtrn = "[]";

        if (cmd == "item")
        {
            rtrn = makejsonoftable(addItem(), makejson.e_with_square_brackets);
            Response.Clear();
            Response.ContentType = "application/json; charset=utf-8";
            Response.Write(rtrn);
            Response.End();
            return;
        }
    }

    public enum makejson
    {
        e_without_square_brackets,
        e_with_square_brackets
    }

    [WebMethod]
    public static string bindData(string PatientID, int type, string IPDNo)
    {
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(" SELECT pm.Patient_ID,CONCAT(pm.Title,' ',pm.PName)PName,pm.Age,pm.Gender,");
            sb.Append(" pm.Country,pm.Mobile ContactNo,CONCAT(pm.House_No,' ,',pm.City)Address,pmh.Transaction_ID,pm.HospPatientType, ");
            if (type == 3)
                sb.Append(" (pmh.Panel_ID)Panel_ID, ");
            else
                sb.Append(" IFNULL(CONCAT(pm.Panel_ID,'#',IF(fpm.paymentMode=4,'1','0')),'')Panel_ID, ");
            sb.Append(" IFNULL(fpm.Company_Name,'')Company_Name,IFNULL(pmh.Doctor_ID,'')Doctor_ID FROM  patient_master pm ");
            if (type == 3)
            {
                sb.Append(" INNER JOIN patient_ipd_profile pid ON pm.Patient_ID=pid.PatientID");
                sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.Transaction_ID=pid.Transaction_ID ");
                sb.Append(" INNER JOIN f_panel_master fpm ON fpm.Panel_id=pmh.Panel_ID");
                sb.Append(" WHERE STATUS='IN' ");
                if (IPDNo.Trim() != "")
                    sb.Append(" AND pid.transaction_id='ISHHI" + IPDNo.Trim() + "' ");
                else if (PatientID.Trim() != "")
                    sb.Append(" AND pid.PatientID='" + PatientID.Trim() + "' ");
            }
            else
            {
                sb.Append("  LEFT JOIN patient_medical_history pmh on pm.Patient_ID=pmh.Patient_ID ");
                sb.Append(" LEFT JOIN f_panel_master fpm ON fpm.Panel_id=pm.Panel_ID WHERE pm.Patient_ID='" + PatientID + "'");
            }
            DataTable dtDetail = StockReports.GetDataTable(sb.ToString());
            if (dtDetail.Rows.Count > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(dtDetail);
            else
                return "";
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "";
        }
    }   

    public DataTable addItem()
    {
        DataTable dt = new DataTable();
        string itemName = Util.GetString(Request.QueryString["q"]);
        if (itemName != "")
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(" Select ST.stockid,REPLACE(ST.ItemName,'\"','\\\\\"') ItemName,CONCAT(ST.ItemID,'#',ST.StockID)ItemID ");
            sb.Append(" ,DATE_FORMAT(st.MedExpiryDate,'%d-%b-%y')Expiry,ST.BatchNumber,");
            sb.Append(" ST.MRP,ST.UnitPrice,(ST.InitialCount - ST.ReleasedCount)AvlQty,IF(IFNULL(fid.Rack,'')='',im.Rack,fid.Rack)Rack, ");

            // Modify on 29-06-2017 - For GST
            // sb.Append(" IF(IFNULL(fid.Shelf,'')='',im.Shelf,fid.Shelf)Shelf ");  
            sb.Append(" IF(IFNULL(fid.Shelf,'')='',im.Shelf,fid.Shelf)Shelf,st.HSNCode "); 

            sb.Append(" FROM f_stock ST INNER JOIN f_itemmaster IM on ST.ItemID=IM.ItemID ");
            sb.Append(" LEFT JOIN f_itemmaster_deptwise fid ON fid.ItemID=IM.ItemID AND fid.DeptLedgerNo='" + lblDeptLedgerNo.Text + "' ");
            sb.Append(" WHERE (ST.InitialCount - ST.ReleasedCount) > 0 AND ST.IsPost = 1 ");
            sb.Append(" AND TRIM(ST.ItemName) LIKE '" + itemName + "%' ");
            sb.Append(" AND st.DeptLedgerNo='" + lblDeptLedgerNo.Text + "' ");
            sb.Append(" AND IF(IM.IsExpirable<>'NO',DATE(st.MedExpiryDate) >= CURDATE(),'01-Jan-01') ");
            sb.Append(" ORDER BY st.MedExpiryDate LIMIT " + Util.GetString(Request.QueryString["rows"]) + " ");

            dt = StockReports.GetDataTable(sb.ToString());
        }
        return dt;
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
                sb2.Append(string.Format("\"{0}\":\"{1}\"", fieldname, fieldvalue.Replace("\n", "<br/>").Replace("\r", "<br/>")));
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

    private void bindTitle()
    {
        ddlTitle.DataSource = AllGlobalFunction.NameTitle;
        ddlTitle.DataBind();
    }   
}