using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_IPD_DischargeDisplayScreenNew : System.Web.UI.Page
{
    private int RCCount, NCCount, PCCount, BGCount, DCount, BFCount, DSCount, DSACount, MCCount, DICount, PCount = (int)0;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["ScreenID"] = 1;
            ViewState["RoleID"] = Session["RoleID"].ToString();
            ucFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            LoadDetails();
        }
        ucFromDate.Attributes.Add("readOnly", "true");
        ucToDate.Attributes.Add("readOnly", "true");
    }

    protected void LoadDetails()
    {
        string SqlQuery = "CALL DishargeDisplayScreen("+ Session["CentreID"].ToString() +");";
        DataTable dt = StockReports.GetDataTable(SqlQuery);

        if (dt.Rows.Count > 0 && dt != null)
        {
            dt.Columns.Add("TAT");
            foreach(DataRow dr in dt.Rows)
            {
                dr["TAT"] = Math.Round((Util.GetDateTime(dr["PatientClearnace"].ToString()) - Util.GetDateTime(dr["Intemation"].ToString())).TotalHours, 2) + " hrs";
                //dr["TAT"] = Util.GetDateTime(dr["PatientClearnace"].ToString()) +"#"+ Util.GetDateTime(dr["Intemation"].ToString());
            }
            grdDischargeScreen.DataSource = dt;
            grdDischargeScreen.DataBind();
        }
        else
        {
            grdDischargeScreen.DataSource = null;
            grdDischargeScreen.DataBind();
        }
    }

    protected void Timer1_Tick(object sender, EventArgs e)
    {
        LoadDetails();
    }

    protected void grdDischargeScreen_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        string IsDisInt = string.Empty; string IsMedClen = string.Empty;
        string IsBillFreezed = string.Empty; string IsDis = string.Empty; string IsBillGen = string.Empty; string IsBillProcess = string.Empty;//
        string IsRoomClean = string.Empty; string IsNurseClearnace = string.Empty; string IsPatClen = string.Empty;

        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            IsDisInt = ((Label)e.Row.FindControl("lblDisInt")).Text;
            IsMedClen = ((Label)e.Row.FindControl("lblMedClen")).Text;
            IsBillFreezed = ((Label)e.Row.FindControl("lblBillFreeze")).Text;
            IsBillProcess = ((Label)e.Row.FindControl("lblBillInProcess")).Text;//
            IsDis = ((Label)e.Row.FindControl("lblDis")).Text;
            IsBillGen = ((Label)e.Row.FindControl("lblBillGen")).Text;
            IsPatClen = ((Label)e.Row.FindControl("lblPatClen")).Text;
            IsNurseClearnace = ((Label)e.Row.FindControl("lblNurseClearnace")).Text;
            IsRoomClean = ((Label)e.Row.FindControl("lblRoomClean")).Text;
            string lblMedClearedTAT = ((Label)e.Row.FindControl("lblMedClearedTAT")).Text;
            string lblBillFreezedTAT = ((Label)e.Row.FindControl("lblBillFreezedTAT")).Text;
            string lblDischargeTAT = ((Label)e.Row.FindControl("lblDischargeTAT")).Text;
            string lblBillGenTAT = ((Label)e.Row.FindControl("lblBillGenTAT")).Text;
            string lblPatClearanceTAT = ((Label)e.Row.FindControl("lblPatClearanceTAT")).Text;
            string lblNurseTAT = ((Label)e.Row.FindControl("lblNurseTAT")).Text;
            string lblRoomTAT = ((Label)e.Row.FindControl("lblRoomTAT")).Text;

            if (IsDisInt != string.Empty)
            {
                ((Image)e.Row.FindControl("imgIntemationGreen")).Visible = true;
                ((Image)e.Row.FindControl("imgIntemationYellow")).Visible = false;
            }
            else
            {
                ((Image)e.Row.FindControl("imgIntemationGreen")).Visible = false;
                ((Image)e.Row.FindControl("imgIntemationYellow")).Visible = true;
            }

            if (lblMedClearedTAT == "true")
            {
                ((Image)e.Row.FindControl("imgMedClearnaceGreen")).Visible = false;
                ((Image)e.Row.FindControl("imgMedClearnaceYellow")).Visible = false;
            }
            else
            {

                if (IsMedClen != string.Empty)
                {
                    ((Image)e.Row.FindControl("imgMedClearnaceGreen")).Visible = true;
                    ((Image)e.Row.FindControl("imgMedClearnaceYellow")).Visible = false;
                }
                else
                {
                    ((Image)e.Row.FindControl("imgMedClearnaceGreen")).Visible = false;
                    ((Image)e.Row.FindControl("imgMedClearnaceYellow")).Visible = true;
                }
            }
            if (lblBillFreezedTAT == "true")
            {
                ((Image)e.Row.FindControl("imgBillFreezeGreen")).Visible = false;
                ((Image)e.Row.FindControl("imgBillFreezeYellow")).Visible = false;
                ((Image)e.Row.FindControl("imgBillInProcessGreen")).Visible = false;
                ((Image)e.Row.FindControl("imgBillInProcessYellow")).Visible = false;
            }
            else
            {

                if (IsBillFreezed != string.Empty)
                {
                    ((Image)e.Row.FindControl("imgBillFreezeGreen")).Visible = true;
                    ((Image)e.Row.FindControl("imgBillFreezeYellow")).Visible = false;
                }
                else
                {
                    ((Image)e.Row.FindControl("imgBillFreezeGreen")).Visible = false;
                    ((Image)e.Row.FindControl("imgBillFreezeYellow")).Visible = true;
                }

                if (IsBillProcess != string.Empty)//
                {
                    ((Image)e.Row.FindControl("imgBillInProcessGreen")).Visible = true;
                    ((Image)e.Row.FindControl("imgBillInProcessYellow")).Visible = false;
                    ((Image)e.Row.FindControl("imgBillInProcessRed")).Visible = false;
                }
                else if (IsMedClen != string.Empty)
                {
                    ((Image)e.Row.FindControl("imgBillInProcessGreen")).Visible = false;
                    ((Image)e.Row.FindControl("imgBillInProcessYellow")).Visible = false;
                    ((Image)e.Row.FindControl("imgBillInProcessRed")).Visible = true;
                }
                else 
                {
                    ((Image)e.Row.FindControl("imgBillInProcessGreen")).Visible = false;
                    ((Image)e.Row.FindControl("imgBillInProcessYellow")).Visible = true;
                    ((Image)e.Row.FindControl("imgBillInProcessRed")).Visible = false;
                }
            }
            if (lblDischargeTAT == "true")
            {
                ((Image)e.Row.FindControl("imgDischargeGreen")).Visible = false;
                ((Image)e.Row.FindControl("imgDischargeYellow")).Visible = false;
            }
            else
            {

                if (IsDis != string.Empty)
                {
                    ((Image)e.Row.FindControl("imgDischargeGreen")).Visible = true;
                    ((Image)e.Row.FindControl("imgDischargeYellow")).Visible = false;
                }
                else
                {
                    ((Image)e.Row.FindControl("imgDischargeGreen")).Visible = false;
                    ((Image)e.Row.FindControl("imgDischargeYellow")).Visible = true;
                }
            }
            if (lblBillGenTAT == "true")
            {
                ((Image)e.Row.FindControl("imgBillGreen")).Visible = false;
                ((Image)e.Row.FindControl("imgBillYellow")).Visible = false;
            }
            else
            {

                if (IsBillGen != string.Empty)
                {
                    ((Image)e.Row.FindControl("imgBillGreen")).Visible = true;
                    ((Image)e.Row.FindControl("imgBillYellow")).Visible = false;
                }
                else
                {
                    ((Image)e.Row.FindControl("imgBillGreen")).Visible = false;
                    ((Image)e.Row.FindControl("imgBillYellow")).Visible = true;
                }
            }
            if (lblPatClearanceTAT == "true")
            {
                ((Image)e.Row.FindControl("imgPatientClearnaceGreen")).Visible = false;
                ((Image)e.Row.FindControl("imgPatientClearnaceYellow")).Visible = false;
            }
            else
            {

                if (IsPatClen != string.Empty)
                {
                    ((Image)e.Row.FindControl("imgPatientClearnaceGreen")).Visible = true;
                    ((Image)e.Row.FindControl("imgPatientClearnaceYellow")).Visible = false;
                }
                else
                {
                    ((Image)e.Row.FindControl("imgPatientClearnaceGreen")).Visible = false;
                    ((Image)e.Row.FindControl("imgPatientClearnaceYellow")).Visible = true;
                }
            }
            if (lblNurseTAT == "true")
            {
                ((Image)e.Row.FindControl("imgNurseClearnaceGreen")).Visible = false;
                ((Image)e.Row.FindControl("imgNurseClearnaceYellow")).Visible = false;
            }
            else
            {

                if (IsNurseClearnace != string.Empty)
                {
                    ((Image)e.Row.FindControl("imgNurseClearnaceGreen")).Visible = true;
                    ((Image)e.Row.FindControl("imgNurseClearnaceYellow")).Visible = false;
                }
                else
                {
                    ((Image)e.Row.FindControl("imgNurseClearnaceGreen")).Visible = false;
                    ((Image)e.Row.FindControl("imgNurseClearnaceYellow")).Visible = true;
                }
            }
            if (lblRoomTAT == "true")
            {
                ((Image)e.Row.FindControl("imgRoomClearnaceGreen")).Visible = false;
                ((Image)e.Row.FindControl("imgRoomClearnaceYellow")).Visible = false;
            }
            else
            {
                if (IsRoomClean != string.Empty)
                {
                    ((Image)e.Row.FindControl("imgRoomClearnaceGreen")).Visible = true;
                    ((Image)e.Row.FindControl("imgRoomClearnaceYellow")).Visible = false;
                }
                else
                {
                    ((Image)e.Row.FindControl("imgRoomClearnaceGreen")).Visible = false;
                    ((Image)e.Row.FindControl("imgRoomClearnaceYellow")).Visible = true;
                }
            }
            DateTime starttime = Util.GetDateTime(IsDisInt);
            DateTime endtime = DateTime.Now;
            if (IsRoomClean != string.Empty)
                endtime = Util.GetDateTime(IsRoomClean);
            TimeSpan differencehours = endtime.Subtract(starttime);
            double cc = differencehours.TotalHours;
            if (differencehours.TotalHours > 3)
                e.Row.BackColor = System.Drawing.Color.Pink;
            //-----------------------------------

            if (((Image)e.Row.FindControl("imgMedClearnaceRed")).Visible == true)
            {
                MCCount = MCCount + 1;
            }
            if (((Image)e.Row.FindControl("imgBillFreezeRed")).Visible == true)
            {
                BFCount = BFCount + 1;
            }
            if (((Image)e.Row.FindControl("imgDischargeRed")).Visible == true)
            {
                DCount = DCount + 1;
            }
            if (((Image)e.Row.FindControl("imgBillRed")).Visible == true)
            {
                BGCount = BGCount + 1;
            }
            if (((Image)e.Row.FindControl("imgPatientClearnaceRed")).Visible == true)
            {
                PCCount = PCCount + 1;
            }
            if (((Image)e.Row.FindControl("imgNurseClearnaceRed")).Visible == true)
            {
                NCCount = NCCount + 1;
            }
            if (((Image)e.Row.FindControl("imgRoomClearnaceRed")).Visible == true)
            {
                RCCount = RCCount + 1;
            }
        }

        if (e.Row.RowType == DataControlRowType.Footer)
        {
            e.Row.HorizontalAlign = HorizontalAlign.Center;
            e.Row.Font.Bold = true;
            if (IsDisInt == string.Empty)
            {
                e.Row.Cells[2].Text = "DI:" + String.Format("{0:d}", DICount);
            }
            if (IsMedClen == string.Empty)
            {
                e.Row.Cells[3].Text = "MC:" + String.Format("{0:d}", MCCount);
            }
            if (IsBillFreezed == string.Empty)
            {
                e.Row.Cells[4].Text = "BF:" + String.Format("{0:d}", BFCount);
            }
            if (IsDis == string.Empty)
            {
                e.Row.Cells[5].Text = "D:" + String.Format("{0:d}", DCount);
            }
            if (IsBillGen == string.Empty)
            {
                e.Row.Cells[6].Text = "BG:" + String.Format("{0:d}", BGCount);
            }
            if (IsPatClen == string.Empty)
            {
                e.Row.Cells[7].Text = "PC:" + String.Format("{0:d}", PCCount);
            }
            if (IsNurseClearnace == string.Empty)
            {
                e.Row.Cells[8].Text = "NC:" + String.Format("{0:d}", NCCount);
            }
            if (IsRoomClean == string.Empty)
            {
                e.Row.Cells[9].Text = "RC:" + String.Format("{0:d}", RCCount);
            }

        }

    }

    protected void btnExporttoExcel_Click(object sender, EventArgs e)
    {


        DataTable dt = new DataTable();
        StringBuilder sb = new StringBuilder();
        try
        {
            sb.Append(" SELECT CONCAT(pm.Title,' ',pm.PName)PatientName,CONCAT(dm.Title,'',dm.Name) AS DoctorName,pnl.Company_Name AS Panel, pmh.TransNo  as TransactionID, ");
            sb.Append(" (SELECT CONCAT(rm.Bed_No,'/',rm.Name) FROM patient_ipd_profile pip INNER JOIN room_master rm ON rm.RoomID=pip.RoomID ");
            sb.Append(" WHERE pip.TransactionID=pmh.TransactionID ORDER BY PatientIPDProfile_ID DESC LIMIT 1 )BedNo, ");
            sb.Append(" (SELECT rm.Name FROM patient_ipd_profile pip INNER JOIN room_master rm ON rm.RoomID=pip.RoomID ");
            sb.Append(" WHERE pip.TransactionID=pmh.TransactionID ORDER BY PatientIPDProfile_ID DESC LIMIT 1 )Ward,IFNULL(em.name,'')DischargedBy , ");
            sb.Append(" IF(pmh.`IsDischargeIntimate`=1,DATE_FORMAT(pmh.DischargeIntimateDate,'%d-%b-%y %I:%i %p'),'')Intemation, ");
            sb.Append(" IF(pmh.IsMedCleared=1,DATE_FORMAT(pmh.MedClearedDate,'%d-%b-%y %I:%i %p'),'')MedClearance, ");
            sb.Append(" IF(pmh.IsBillFreezed=1,DATE_FORMAT(pmh.BillFreezedTimeStamp,'%d-%b-%y %I:%i %p'),'')BillFreeze,  ");
            sb.Append(" IF(pmh.Status='OUT',DATE_FORMAT(CONCAT(pmh.DateOfDischarge,' ',pmh.TimeOfDischarge),'%d-%b-%y %I:%i %p'),'')DischargeDate,  ");
            sb.Append(" IF((IFNULL(pmh.BillNo,''))<>'',DATE_FORMAT(pmh.BillDate,'%d-%b-%y %I:%i %p'),'')BillDate, ");
            sb.Append(" IF(pmh.IsClearance=1,DATE_FORMAT(pmh.ClearanceTimeStamp,'%d-%b-%y %I:%i %p'),'')PatientClearance, ");
            sb.Append(" IF(pmh.IsNurseClean=1,DATE_FORMAT(pmh.NurseCleanTimeStamp,'%d-%b-%y %I:%i %p'),'')NurseClearance, ");
            sb.Append(" IF(pmh.IsRoomClean=1,DATE_FORMAT(pmh.RoomCleanTimeStamp,'%d-%b-%y %I:%i %p'),'')RoomClearance ");
            sb.Append(" FROM patient_medical_history pmh  ");
            sb.Append(" INNER JOIN patient_master pm ON pmh.PatientID=pm.PatientID ");
            sb.Append(" INNER JOIN f_panel_master pnl ON pnl.PanelID=pmh.PanelID INNER JOIN Doctor_master dm ON dm.DoctorID=pmh.DoctorID LEFT JOIN employee_master em ON em.employeeid=pmh.DischargedBy ");
            sb.Append(" WHERE pmh.Type='IPD' AND pmh.`IsDischargeIntimate`=1 AND pmh.CentreID = "+ Session["CentreID"].ToString() +" ");
            if (Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") != string.Empty)
                sb.Append(" and pmh.DateOfDischarge >= '" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "'  ");
            if (Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") != string.Empty)
                sb.Append(" AND pmh.DateOfDischarge <= '" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "'  ");
            sb.Append(" ORDER BY pmh.TransNo  ");

            dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                string strDate = "";
                strDate = " Between  " + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + " To  " + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd");
                Session["dtExport2Excel"] = dt;
                Session["Period"] = strDate;
                Session["ReportName"] = "Discharge Display Screen Report ";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);
            }
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
    }
}