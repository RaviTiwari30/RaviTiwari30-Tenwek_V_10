using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Web.UI;

public partial class Design_IPD_CommonReceipt : System.Web.UI.Page
{
    // private MySqlConnection con = new MySqlConnection();

    protected override void InitializeCulture()
    {
        base.InitializeCulture();

        System.Threading.Thread.CurrentThread.CurrentUICulture = new CultureInfo(Resources.Resource.Lang_Code);
        //System.Threading.Thread.CurrentThread.CurrentCulture = new CultureInfo("fr-FR");
    }

    protected void Page_Load(object sender, EventArgs e)
    {



        if (Request.QueryString.Count == 0 && Util.GetString(Request.QueryString["access"]) == "")
        {
            Response.Redirect(Request.RawUrl + "?access=" + Util.getHash());
        }
        else if (Request.QueryString.Count > 0 && Util.GetString(Request.QueryString["access"]) == "")
        {
            Response.Redirect(Request.RawUrl + "&access=" + Util.getHash());
        }

        lblHeaderText.Text = StockReports.ExecuteScalar("select HeaderText from Receipt_Header WHERE HeaderType='OPD' ");

        string LedgerTransactionNo = Util.GetString(Request.QueryString["LedgerTransactionNo"]);

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT LTD.ItemID,LTD.SubCategoryID,LTD.ItemName AS Item, ");
        sb.Append("  LTD.Rate,'' SubCategory,LTD.Quantity,LTD.DiscountPercentage,LT.DiscountOnTotal,");
        sb.Append(" EM.Name AS PreparedBy,lt.LedgerTransactionNo,lt.Date,lt.Time,CONCAT(lt.Date,' ',lt.Time)EntDate, ");
        sb.Append("  IF(LT.BillNo IS NULL, ' ',LT.BillNo) BillNo,LT.PatientID AS PatientID,Relation,RelationName,LT.NetAmount AS TotalRate,LT.PaymentModeID, ");
        sb.Append(" LT.DiscountReason,Lt.PanelID,Lt.TransactionID ,IFNULL(LT.IPNo,'')IPNo,");
        sb.Append(" LT.TypeOfTnx AS TransactionType,lt.RoundOff,CONCAT(PM.title,' ',PM.PName)PatientName,FPM.Company_Name AS PanelName,lt.GovTaxPer,lt.GovTaxAmount,");
        sb.Append(" CONCAT(IFNULL(PM.House_No,''),' ',IFNULL(pm.Street_Name,''),' ', IFNULL(pm.Locality,''),'-',IFNULL(pm.City,''),', ',IFNULL(pm.Country,'')) Address, ");
        sb.Append(" IFNULL(pm.City,'')City,pm.Age,PM.Gender,IF(IFNULL(pm.Mobile,'')='',IFNULL(pm.Phone,''),IF(pm.Phone <>'',CONCAT(pm.Mobile,'/',pm.Phone),pm.Mobile))Mobile,IFNULL( CONCAT(dm.`Title`,' ' , dm.`Name`,'(',dm.Specialization,')'),'') AS DoctorName, ");
        sb.Append(" IFNULL(PMH.ReferedBy,'')ReferedBy,PMH.Source,ltd.configId ");
        sb.Append(" FROM f_ledgertransaction LT  INNER JOIN f_ledgertnxdetail LTD ON LT.LedgerTransactionNo=LTD.LedgerTransactionNo INNER JOIN ");
        sb.Append(" patient_master PM ON Lt.PatientID=PM.PatientID INNER JOIN Patient_Medical_History PMH ON LT.TransactionID=PMH.TransactionID INNER JOIN f_panel_master FPM ON pmh.PanelID=FPM.PanelID INNER JOIN employee_master EM");
        sb.Append(" ON Lt.UserID=EM.EmployeeID LEFT JOIN doctor_master dm ON dm.DoctorID=pmh.DoctorID ");
        sb.Append(" WHERE  LT.LedgerTransactionNo='" + LedgerTransactionNo + "' AND ltd.isVerified=1 ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {

            lblHeader.Text = "IPD Bill";
            lblIPD.Visible = true;
            lblIP.Visible = true;
            lblIPDNo.Visible = true;
            lblIPDNo.Text = dt.Rows[0]["TransactionID"].ToString().Replace("ISHHI", "");

            if (dt.Rows[0]["Relation"].ToString() != "")
            {
                lblreldot.Visible = true;
            }
            if (dt.Columns.Contains("DisplayName") == false) dt.Columns.Add("DisplayName");
            AllQuery AQ = new AllQuery();
            string SubCat = "";
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                SubCat = AQ.GetSubCategoryDisplayNameBySubCategoryID(dt.Rows[i]["SubCategoryID"].ToString());
                dt.Rows[i]["SubCategory"] = SubCat.Split('#')[0].ToString();
                dt.Rows[i]["DisplayName"] = SubCat.Split('#')[1].ToString();
            }

            DataView dv = dt.DefaultView;
            dv.Sort = "DisplayName,SubCategory";
            dt = dv.ToTable();
        }
        lblRelation.Text = dt.Rows[0]["Relation"].ToString();
        lblRelationName.Text = dt.Rows[0]["RelationName"].ToString();
        LblPatientName.Text = Util.GetString(dt.Rows[0]["PatientName"].ToString());

        string str2 = " SELECT CONCAT(NAME,'/',Room_No,'/',bed_no)room FROM patient_ipd_profile pif INNER JOIN room_master rm ON pif.RoomID=rm.RoomId WHERE patientID = '" + dt.Rows[0]["PatientId"].ToString() + "' AND STATUS ='IN' ";

        DataTable dt1 = StockReports.GetDataTable(str2.ToString());
        if (dt1.Rows.Count > 0)
        {
            lblward.Visible = true;
            lblroom.Visible = true;
            lblroomward.Text = dt1.Rows[0]["room"].ToString();
        }
        LblDate.Text = Util.GetDateTime(dt.Rows[0]["Date"].ToString()).ToString("dd-MMM-yyyy");
        LblTime.Text = Util.GetDateTime(dt.Rows[0]["Time"].ToString()).ToString("hh:mm tt");
        LblReceiptNo.Text = Util.GetString(dt.Rows[0]["BillNO"].ToString());
        lblRecp.Text = "Bill No.";

        if ((dt.Columns.Contains("PanelID") == true) && (dt.Rows[0]["PanelID"].ToString().Trim() != "0"))
        {
            if (Util.GetInt(dt.Rows[0]["PanelID"].ToString().Trim()) != 0)
            {
                lblPanelName.Visible = true;
                lblPanel.Visible = true;
                lblPanel.Text = dt.Rows[0]["PanelName"].ToString().Trim();
            }
            else
            {
                lblPanelName.Visible = false;
                lblPanel.Visible = true;
                lblPanel.Text = "";
            }
        }
        LblAgeSex.Text = Util.GetString(dt.Rows[0]["Age"].ToString()) + @" / " + Util.GetString(dt.Rows[0]["Gender"].ToString());
        lblAddress.Text = Util.GetString(dt.Rows[0]["Address"].ToString());
        lblCity.Text = Util.GetString(dt.Rows[0]["City"].ToString());
        lblMobile.Text = Util.GetString(dt.Rows[0]["Mobile"].ToString());
        LblRegNo.Text = Util.GetString(dt.Rows[0]["PatientId"].ToString());
        LblDoctorName.Text = Util.GetString(dt.Rows[0]["DoctorName"].ToString().ToUpper());
        var filteredType = dt.AsEnumerable().Where(d => d.Field<int>("configID") == 3).Count();

        if (filteredType > 0)
        {
            lblLabNoHeading.Visible = true;
            lblLabNo.Visible = true;
            lbla.Visible = true;
            lblLabNo.Text = Util.GetString(dt.Rows[0]["LedgerTransactionNo"].ToString().Replace("LOSHHI", "1").Replace("LSHHI", "2").Replace("LISHHI", "3"));
           
        }


        PlaceHolder1.Controls.Add(new LiteralControl("<Table width=100% class = 'textreceipt' border=0 cellpadding=0 cellspacing=0 >"));
        Decimal Total = 0.0m;
        Decimal Total1 = 0.0m;
        Decimal Rate = 0.0m;
        Decimal Quantity = 0.0m;
        string DisplayName = "";
        decimal TotalRate = 0.0m;
        decimal TotalRate1 = 0.0m;
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            if (dt.Rows[i]["DisplayName"].ToString().Trim() != "")
            {
                if (DisplayName != dt.Rows[i]["DisplayName"].ToString())
                {
                    DisplayName = dt.Rows[i]["DisplayName"].ToString();
                    PlaceHolder1.Controls.Add(new LiteralControl("<tr><td width=50% height=2px align=left valign=top  align=left ><strong>" + DisplayName.ToUpper() + "</strong></td><td width=50% valign=top height=2px align=right colspan=3></td></tr>"));
                }
            }
            else
            {
                if (DisplayName != dt.Rows[i]["SubCategory"].ToString())
                {
                    DisplayName = dt.Rows[i]["DisplayName"].ToString();
                    PlaceHolder1.Controls.Add(new LiteralControl("<tr><td width=50% height=2px align=left valign=top ><strong>" + DisplayName.ToUpper() + "</strong></td><td width=50% valign=top height=2px align=right colspan=3></td></tr>"));
                }
            }

            TotalRate = Util.GetDecimal(dt.Rows[i]["Rate"]) * Util.GetDecimal(dt.Rows[i]["Quantity"]);
            Rate = Math.Round(Util.GetDecimal(dt.Rows[i]["Rate"]), 2);
            Quantity = Math.Round(Util.GetDecimal(dt.Rows[i]["Quantity"]), 2);
            TotalRate1 = Util.GetDecimal(dt.Rows[i]["TotalRate"]);
            PlaceHolder1.Controls.Add(new LiteralControl("<tr><td width=60% height=2px valign=top  align=left>&nbsp;&nbsp;" + Util.GetString(dt.Rows[i]["Item"].ToString().ToUpper()) + "</td><td width=12% valign=top height=2px align=right>" + Quantity.ToString("f2") + "</td><td width=14% valign=top height=2px align=right>" + Rate.ToString("f2") + "</td><td width=14% valign=top height=2px align=right>" + TotalRate.ToString("f2") + "</td></tr>"));
            Total = Total + Util.GetDecimal(TotalRate);
            Total1 = Util.GetDecimal(TotalRate1);

        }
        PlaceHolder1.Controls.Add(new LiteralControl("</Table>"));
        if (Total.ToString().Contains("-"))
        {
            LblTotal.Text = Total.ToString("f2").Remove(0, 1);
        }
        else
        {
            LblTotal.Text = Total.ToString("f2");
        }
        if ((LblDate.Text != "") && (LblTime.Text != ""))
        {
            if (Resources.Resource.Lang_Code == "fr-FR")
            {
                lblfooter.Text = LblDate.Text + "  " + LblTime.Text + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Préparé Par :  " + dt.Rows[0]["PreparedBy"].ToString() + " &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Imprimé Par : " + Util.GetString(Session["LoginName"].ToString());
            }
            else
            {
                lblfooter.Text = LblDate.Text + "  " + LblTime.Text + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Prepared By :  " + dt.Rows[0]["PreparedBy"].ToString() + " &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Printed By : " + Util.GetString(Session["LoginName"].ToString());
            }
        }
       
        lblLabNo.Text = lblLabNo.Text.Replace("LOSHHI", "1");

        if (LblDoctorName.Text.ToLower() == "dr. -")
            LblDoctorName.Text = "";



    }

}