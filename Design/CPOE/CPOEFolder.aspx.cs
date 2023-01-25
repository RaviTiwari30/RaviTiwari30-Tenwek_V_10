using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using System.Web.Services;
using System.IO;

public partial class Design_CPOE_CPOEFolder : System.Web.UI.Page
{

    public string TID = string.Empty, PatientID = string.Empty, IsDone = string.Empty, LnxNo = string.Empty, App_ID = string.Empty, RoleID = string.Empty, Sex = string.Empty, PanelID = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            try
            {


             
               var TID = Convert.ToString(Request.QueryString["TID"]);
               ViewState["roleID"] = Session["RoleID"].ToString();
               ViewState["defaultUrl"] = "cpoe_Vital.aspx";

               if (TID == null || TID == string.Empty)
                   TID = "0";

                int isview = Util.GetInt(StockReports.ExecuteScalar("SELECT isView from appointment WHERE TransactionID='" + TID + "' "));
                if (Session["RoleID"].ToString() == "52")
                {
                    if (isview == Util.GetInt("0"))
                    {
                        string str = "UPDATE appointment SET isView=1,isViewDate=NOW(),ViewBy='" + Session["ID"] + "' WHERE  TransactionID='" + TID + "'";
                        StockReports.ExecuteDML(str);
                    }
                    All_LoadData.updateNotification(Convert.ToString(Request.QueryString["APP_ID"]), Util.GetString(Session["ID"].ToString()), "", 1);
                }

                //Insert Patient Viewed Tab Information (Doctor and Temp Menus only)
                int Count = Util.GetInt(StockReports.ExecuteScalar("Select count(*) from CPOE_Viewed_tab where TransactionID='" + TID + "'"));
                if (Count == 0)
                {
                    string sqlQry = "Insert into CPOE_Viewed_tab(TransactionID,PatientID,TabID) select '" + TID + "' TransactionID,'" + PatientID + "' PatientID, ID TabID FROM cpoe_menumaster WHERE roleID IN (52,226) AND Isactive=1 ";

                    StockReports.ExecuteDML(sqlQry);
                }
                TID = Convert.ToString(Request.QueryString["TID"]);
                PatientID = Convert.ToString(Request.QueryString["PatientID"]);
                App_ID = Convert.ToString(Request.QueryString["App_ID"]);
                LnxNo = Convert.ToString(Request.QueryString["LnxNo"]);
                IsDone = Convert.ToString(Request.QueryString["IsDone"]);
                Sex = Convert.ToString(Request.QueryString["Sex"]);
                PanelID = Convert.ToString(Request.QueryString["PanelID"]);
                ViewState["ID"] = Session["ID"].ToString();
                if (Session["RoleID"].ToString() == "52" || Session["RoleID"].ToString() == "323")
                {
                    RoleID = "52";
                }
                else
                    RoleID = Session["RoleID"].ToString();
                GenerateMainMenu(RoleID, TID);
                GetPatientImage(PatientID);
                
            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
            }
        }
        if (Session["LoginType"] == null && Session["UserName"] == null)
        {
            Response.Redirect("Default.aspx");
        }
    }


     public void GetPatientImage(string PatientID) {
        try
        {
            DateTime DateEnrolle = Util.GetDateTime(StockReports.ExecuteScalar("select DateEnrolled from Patient_master where PatientID='" + PatientID + "'"));
            string Gender = Util.GetString(StockReports.ExecuteScalar("select Gender from Patient_master where PatientID='" + PatientID + "'"));
            PatientID = PatientID.Replace("/", "_");
            //string PImagePath = System.IO.Path.Combine(Resources.Resource.DocumentDriveIPAddress + Resources.Resource.DocumentDriveName + "\\" + Resources.Resource.DocumentFolderName + "\\PatientPhoto\\" + DateEnrolle.Year + "\\" + DateEnrolle.Month + "\\" + PatientID + ".jpg");
            //if (File.Exists(PImagePath))
            //{
            //    byte[] byteArray = File.ReadAllBytes(PImagePath);
            //    string base64 = Convert.ToBase64String(byteArray);
            //    imgPatient.Src = string.Format("data:image/jpg;base64,{0}", base64);
            //}
           // else
           // {
                //check gender
                if (Gender == "Male")
                {
                    imgPatient.Src = "~/Images/MaleDefault.png";
                }
                else if (Gender == "Female")
                {
                    imgPatient.Src = "~/Images/FemaleDefault.png";
                }
            //}
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    
    }





    public void GetPatientIPDInfo()
    {
        try
        {
            string strQuery = "";
            string str = "Select min(ID) from f_doctorshift where TransactionID = '" + ViewState["TransactionID"] + "'";
            string min = StockReports.ExecuteScalar(str);
            strQuery = "select CONCAT(Title,'',Name)DoctorName,df.DoctorID, CONCAT(Date_Format(df.FromDate,'%d-%b-%Y'),' ',Time_format(df.FromTime,'%h:%i %p'))DateOfAdmit from f_doctorshift df inner join doctor_master dm on dm.DoctorID=df.DoctorID where df.ID=" + min + "  ";
            DataTable dt = new DataTable();
            dt = StockReports.GetDataTable(strQuery);
            ViewState["dt"] = dt;
        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }

    }

    private void BindPatientDetails(string TransactionID)
    {
        try
        {
            string Status = StockReports.ExecuteScalar("Select Status from IPD_case_History where TransactionID='" + TransactionID + "'");

            AllQuery AQ = new AllQuery();
            DataTable dt = AQ.GetPatientIPDInformation("", TransactionID, Status);
            if (dt != null && dt.Rows.Count > 0)
            {
                //pnlPatient.Visible = true;//old
                //lblPatientID.Text = dt.Rows[0]["PatientID"].ToString();
                //PatientID = lblPatientID.Text;
                //lblPatientName.Text = dt.Rows[0]["Title"].ToString() + " " + dt.Rows[0]["PName"].ToString();
                //lblTransactionNo.Text = dt.Rows[0]["Transaction_ID"].ToString().Replace("ISHHI", "");
                //lblRoomNo.Text = dt.Rows[0]["RoomNo"].ToString();
                //lblPanelComp.Text = dt.Rows[0]["Company_Name"].ToString();
                //lblAllergies.Text = StockReports.ExecuteScalar("SELECT Allergies FROM cpoe_hpexam WHERE PatientID='" + dt.Rows[0]["PatientID"].ToString() + "' ORDER BY PastHistoryEntryDate DESC LIMIT 1");

                //lblDOB.Text = dt.Rows[0]["Age"].ToString();
                //lblMLCNo.Text = dt.Rows[0]["MLC_NO"].ToString();
                //lblSex.Text = dt.Rows[0]["gender"].ToString();
            }
                    //DataTable dt1 = (DataTable)ViewState["dt"];
                    //if (dt1 != null && dt1.Rows.Count > 0)
                    //{
                    //    lblAdmissionDate.Text = Util.GetDateTime(dt1.Rows[0]["DateOfAdmit"].ToString()).ToString("dd-MMM-yyyy hh:mm tt");
                    //}
            dt = AQ.GetPatientIPDInformation(TransactionID);

            if (dt != null && dt.Rows.Count > 0)
            {
                //lblcurrntcunsltnt.Text = dt.Rows[0]["DoctorName"].ToString();
                //lblAdmissionDate.Text = Util.GetDateTime(dt.Rows[0]["DateOfAdmit"].ToString()).ToString("dd-MMM-yyyy hh:mm tt");
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }
    [WebMethod]
    public static string BindBillDetails(string TransactionID, string PatientID)
    {
        AllQuery AQ = new AllQuery();
        decimal TotalDisc = Math.Round(Util.GetDecimal(StockReports.ExecuteScalar("Select (IFNULL(sum((Rate*Quantity)-Amount),0) + (Select IFNULL(DiscountOnBill,0) from f_ipdadjustment where TransactionID='" + TransactionID + "')) TotalDisc from f_ledgertnxdetail where TransactionID='" + TransactionID + "' and DiscountPercentage > 0  and isverified=1 and ispackage=0")), 2, MidpointRounding.AwayFromZero);
        decimal AmountBilled = Math.Round(Util.GetDecimal(AQ.GetBillAmount(TransactionID, null)) - Util.GetDecimal(TotalDisc), 2, MidpointRounding.AwayFromZero);
        decimal TaxPer = Math.Round(Util.GetDecimal(All_LoadData.GovTaxPer()), 2, MidpointRounding.AwayFromZero);
        decimal TaxAmount = Util.GetDecimal(Math.Round(Util.GetDecimal((Util.GetDecimal(AmountBilled) * Util.GetDecimal(TaxPer)) / 100), 2, System.MidpointRounding.AwayFromZero));
        decimal TotalAmt = Math.Round(Util.GetDecimal(AmountBilled) + Util.GetDecimal(TaxAmount), 2, MidpointRounding.AwayFromZero);
        decimal NetBillAmount = Util.GetDecimal(Math.Round(TotalAmt, 0, MidpointRounding.AwayFromZero));
        decimal RoundOff = Math.Round((Util.GetDecimal(NetBillAmount) - TotalAmt), 2, MidpointRounding.AwayFromZero);
        decimal TotalDeduction = Math.Round(Util.GetDecimal(AQ.GetTDS(TransactionID)) + Util.GetDecimal(AQ.GetTotalDedutions(TransactionID) + Util.GetDecimal(AQ.GetWriteoff(TransactionID))), 2, MidpointRounding.AwayFromZero);
        decimal Advance = Math.Round(Util.GetDecimal(AQ.GetPaidAmount(TransactionID)), 2, MidpointRounding.AwayFromZero);
        decimal BalanceAmt = Math.Round(Util.GetDecimal(NetBillAmount) - (Util.GetDecimal(Advance) + TotalDeduction), 2, MidpointRounding.AwayFromZero); ;
        string OutStanding = StockReports.ExecuteScalar("SELECT PatientOutstanding('" + PatientID + "')");
      //  string BillDetail = TotalDisc + "#" + AmountBilled + "#" + TaxPer + "#" + TaxAmount + "#" + TotalAmt + "#" + NetBillAmount + "#" + RoundOff + "#" + TotalDeduction + "#" + Advance + "#" + BalanceAmt + "#" + OutStanding;
        return Newtonsoft.Json.JsonConvert.SerializeObject(new{
               totalDiscount=TotalDisc,
               amountBilled = AmountBilled,
               taxPercent = TaxPer,
               taxAmount = TaxAmount,
               totalAmount = TotalAmt,
               netBillAmount = NetBillAmount,
               roundOff = RoundOff,
               totalDeduction = TotalDeduction,
               advance = Advance,
               balanceAmt = BalanceAmt,
               outStanding =OutStanding,
        });
    }
    [WebMethod]
    public static string BindVitals(string TransactionID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ipo.Temp,ipo.POD,ipo.Pulse,ipo.Resp,ipo.BP,ipo.wound,ipo.drains,ipo.BloodSugar,ipo.Weight,ipo.Oxygen,ipo.comments,Replace(ipo.TransactionID,'ISHHI','')IPDNo,ipo.PatientID,ipo.CreatedBy, ");
        sb.Append(" TIMESTAMPDIFF(MINUTE,CreatedDate,NOW())createdDateDiff FROM IPD_Patient_ObservationChart ipo ");
        sb.Append(" WHERE ipo.transactionID = '" + TransactionID + "' GROUP BY ipo.ID order by ipo.Date Desc,ipo.time desc Limit 1 ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";

    }


    //public void GenerateMenu(string RoleID, string transactionID)
    //{
    //    try
    //    {

    //        //var transactionID = Convert.ToString(Request.QueryString["TID"]);
    //        //var PatientID = Convert.ToString(Request.QueryString["PatientID"]);
    //        //var App_ID = Convert.ToString(Request.QueryString["App_ID"]);
    //        //var LnxNo = Convert.ToString(Request.QueryString["LnxNo"]);
    //        //var IsDone = Convert.ToString(Request.QueryString["IsDone"]);
    //        //var Sex = Convert.ToString(Request.QueryString["Sex"]);
    //        //var PanelID = Convert.ToString(Request.QueryString["PanelID"]);
    //        //ViewState["ID"] = Session["ID"].ToString();
    //        //var RoleID = Session["RoleID"].ToString();

    //        StringBuilder sb = new StringBuilder();
    //        sb.Append(" SELECT COUNT(*) FROM cpoe_menu cm INNER JOIN doctor_employee de ON cm.DoctorID=de.DoctorID ");
    //        sb.Append(" WHERE RoleID='" + RoleID + "' AND de.EmployeeID='" + HttpContext.Current.Session["ID"].ToString() + "' ");

    //        int count = Util.GetInt(StockReports.ExecuteScalar(sb.ToString()));
    //        sb.Clear();
    //        sb.Append(" SELECT if(ifnull(vt.ID,'')='','','1')MenuColor,cmm.MenuName,cmm.id,cmm.URL,'Contentframe' Target FROM cpoe_menumaster cmm ");
    //        if (count > 0)
    //        {
    //            sb.Append(" INNER JOIN cpoe_menu cm ON cmm.id=cm.menuid ");
    //            sb.Append(" INNER JOIN  doctor_employee de ON cm.DoctorID=de.DoctorID  ");

    //            //Bind Color of the Viewed and Saved Forms Tabs

    //            sb.Append(" Left join CPOE_Viewed_tab vt on vt.TabID=cmm.ID and vt.TransactionID='" + transactionID + "' AND STATUS=1 ");

    //            sb.Append(" WHERE de.EmployeeID='" + HttpContext.Current.Session["ID"].ToString() + "' ");
    //            sb.Append(" AND  cm.IsActive = 1 AND cm.RoleId='" + RoleID + "'  ORDER BY cm.SequenceNo+0 ");
    //        }
    //        else
    //        {
    //            sb.Append(" Left join CPOE_Viewed_tab vt on vt.TabID=cmm.ID and vt.TransactionID='" + transactionID + "' AND STATUS=1 ");
    //            sb.Append("  WHERE cmm.IsActive = 1  AND cmm.RoleId='" + RoleID + "'  ORDER BY cmm.SequenceNo+0  ");
    //        }

    //        DataTable dt = StockReports.GetDataTable(sb.ToString());
    //        rptMainMenu.DataSource = dt;
    //        rptMainMenu.DataBind();
    //    }

    //    catch (Exception ex)
    //    {
    //        ClassLog cl = new ClassLog();
    //        cl.errLog(ex);

    //    }
    //}


    public void GenerateMainMenu(string RoleID, string transactionID)
    {

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT COUNT(*) FROM cpoe_menu cm INNER JOIN doctor_employee de ON cm.DoctorID=de.DoctorID ");
        sb.Append(" WHERE RoleID='" + RoleID + "' AND de.EmployeeID='" + HttpContext.Current.Session["ID"].ToString() + "' ");

        int count = Util.GetInt(StockReports.ExecuteScalar(sb.ToString()));
        sb.Clear();
        sb.Append(" SELECT  DISTINCT(IFNULL(IF(cmm.MenuHeader='','Others',cmm.MenuHeader),'Others'))MenuName FROM cpoe_menumaster cmm ");
        if (count > 0)
        {
            sb.Append(" INNER JOIN cpoe_menu cm ON cmm.id=cm.menuid ");
            sb.Append(" INNER JOIN  doctor_employee de ON cm.DoctorID=de.DoctorID  ");

            //Bind Color of the Viewed and Saved Forms Tabs

            sb.Append(" Left join CPOE_Viewed_tab vt on vt.TabID=cmm.ID and vt.TransactionID='" + transactionID + "' AND STATUS=1 ");

            sb.Append(" WHERE de.EmployeeID='" + HttpContext.Current.Session["ID"].ToString() + "' ");
            sb.Append(" AND  cm.IsActive = 1 AND cm.RoleId='" + RoleID + "'  ORDER BY cm.SequenceNo+0 ");
        }
        else
        {
            sb.Append(" Left join CPOE_Viewed_tab vt on vt.TabID=cmm.ID and vt.TransactionID='" + transactionID + "' AND STATUS=1 ");
            sb.Append("  WHERE cmm.IsActive = 1  AND cmm.RoleId='" + RoleID + "'  ORDER BY cmm.SequenceNo+0  ");
        }

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        rptMainMenu.DataSource = dt;
        rptMainMenu.DataBind();
    }



    protected void rptMainMenu_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            Repeater rptSubMenu = e.Item.FindControl("rptChildMenu") as Repeater;

            Label a1 = (Label)e.Item.FindControl("lblMenuName");
            var MenuName = a1.Text;
            
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT COUNT(*) FROM cpoe_menu cm INNER JOIN doctor_employee de ON cm.DoctorID=de.DoctorID ");
            sb.Append(" WHERE RoleID='" + RoleID + "' AND de.EmployeeID='" + HttpContext.Current.Session["ID"].ToString() + "' ");

            int count = Util.GetInt(StockReports.ExecuteScalar(sb.ToString()));
            sb.Clear();
            sb.Append(" SELECT if(ifnull(vt.ID,'')='','','1')MenuColor,cmm.MenuName,cmm.id,cmm.URL,'Contentframe' Target FROM cpoe_menumaster cmm ");
            if (count > 0)
            {
                sb.Append(" INNER JOIN cpoe_menu cm ON cmm.id=cm.menuid ");
                sb.Append(" INNER JOIN  doctor_employee de ON cm.DoctorID=de.DoctorID  ");

                //Bind Color of the Viewed and Saved Forms Tabs

                sb.Append(" Left join CPOE_Viewed_tab vt on vt.TabID=cmm.ID and vt.TransactionID='" +  Convert.ToString(Request.QueryString["TID"]) + "' AND STATUS=1 ");

                sb.Append(" WHERE de.EmployeeID='" + HttpContext.Current.Session["ID"].ToString() + "' ");
                if (MenuName.ToString() != "")
                {
                    if (MenuName.ToString() == "Others")
                    {
                        sb.Append("  and  IFNULL(cmm.MenuHeader,'')=''  ");

                    }
                    else
                    {
                        sb.Append("  and cmm.MenuHeader like '%" + MenuName + "%'  ");

                    }
                }
                sb.Append(" AND  cm.IsActive = 1 AND cm.RoleId='" + RoleID + "'  ORDER BY cm.SequenceNo+0 ");
            }
            else
            {
                sb.Append(" Left join CPOE_Viewed_tab vt on vt.TabID=cmm.ID and vt.TransactionID='" +  Convert.ToString(Request.QueryString["TID"]) + "' AND STATUS=1 ");
                sb.Append("  WHERE cmm.IsActive = 1  ");
                if (MenuName.ToString() != "")
                {
                    if (MenuName.ToString() == "Others")
                    {
                        sb.Append("  and  IFNULL(cmm.MenuHeader,'')=''  ");

                    }
                    else
                    {
                        sb.Append("  and cmm.MenuHeader like '%" + MenuName + "%'  ");

                    }
                }
                sb.Append(" AND cmm.RoleId='" + RoleID + "'  ORDER BY cmm.SequenceNo+0  ");
            }

            DataTable dt = StockReports.GetDataTable(sb.ToString());


            rptSubMenu.DataSource = dt;
            rptSubMenu.DataBind();

        }




    }





}