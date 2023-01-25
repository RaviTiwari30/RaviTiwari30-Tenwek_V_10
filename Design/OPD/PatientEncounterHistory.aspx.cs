using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_OPD_PatientEncounterHistory : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtSearchFromDate.Text = Util.GetDateTime(DateTime.Now).ToString("dd-MMM-yyyy");
            txtSearchToDate.Text = Util.GetDateTime(DateTime.Now).ToString("dd-MMM-yyyy");
        
            BindCentre();
            
        }
    }



    [WebMethod(EnableSession = true)]
    public static string GetDataToFill(string chkDate, string PatientId, string EncounterNo, string FromDate, string ToDate, int IsEmg,string CentreId)
    {

        try
        {
            StringBuilder sbnew = new StringBuilder();
            if (Util.GetInt(IsEmg)==0)
            {
                sbnew = new StringBuilder();
                
                sbnew.Append("SELECT * FROM( ");
                sbnew.Append(" SELECT cm.`CentreName`,IsPhoneConsultation,'OPD' Typ , CONCAT(pm.Title,' ',pm.PName)NAME,pm.Age,pm.Gender Sex,pe.EncounterNo EncounterNo, ");
                sbnew.Append(" pe.ID EncounterId,pe.PatientID PatientId,DATE_FORMAT( pe.DateTime ,'%d-%b-%Y' )EntryDate, ");
                sbnew.Append(" IF(pe.Active=1,'Open','Closed')STATUS,pm.PanelID PanelId ");
                sbnew.Append(" FROM patient_encounter pe ");
                sbnew.Append(" INNER JOIN patient_master pm ON pm.PatientID=pe.PatientID ");
                sbnew.Append(" INNER JOIN center_master cm  ON cm.CentreID=pm.CentreID ");
                 
                sbnew.Append(" WHERE  pe.PatientID= if(ifnull('" + PatientId + "','')='',pe.PatientID,'" + PatientId + "')    ");
                if (chkDate != "0")
                {
                    sbnew.Append(" and  DATE(pe.DateTime) between '" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' ");
                    sbnew.Append("     and '" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' ");
                }
                //sbnew.Append(" and  pe.Id= IF(IFNULL(" + Util.GetInt(EncounterNo) + ",0)=0,pe.Id," + Util.GetInt(EncounterNo) + ")  ");
                if (EncounterNo != "")
                {
                    sbnew.Append(" and  pe.EncounterNo= '" + EncounterNo + "' ");
                }
                if (!string.IsNullOrEmpty(CentreId) && CentreId!="All")
                {
                    sbnew.Append(" and   pm.`CentreID`= '" + CentreId + "' ");
                   
                }

                sbnew.Append(" ORDER BY pe.ID DESC ");

            sbnew.Append(" )t");
            if (PatientId != "")
            {
                sbnew.Append(" Union All ");
                sbnew.Append(" SELECT * FROM( ");
                sbnew.Append(" SELECT  cm.`CentreName`,0 IsPhoneConsultation ,'IPD' Typ ,CONCAT(pm.Title,' ',pm.PName)NAME,pm.Age,pm.Gender Sex, pe.TransactionID EncounterNo, ");
                sbnew.Append(" pe.TransactionID EncounterId,pe.PatientID PatientId,DATE_FORMAT( pe.StartDate ,'%d-%b-%Y' )EntryDate,  ");
                sbnew.Append(" pe.status STATUS,pe.PanelId ");
                sbnew.Append(" FROM patient_ipd_profile pe ");
                sbnew.Append(" INNER JOIN patient_master pm ON pm.PatientID=pe.PatientID ");
                sbnew.Append(" INNER JOIN center_master cm  ON cm.CentreID=pm.CentreID ");
                 
                sbnew.Append(" WHERE  pe.PatientID= if(ifnull('" + PatientId + "','')='',pe.PatientID,'" + PatientId + "')    ");
                if (chkDate != "0")
                {
                    sbnew.Append(" and  DATE(pe.StartDate) between '" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' ");
                    sbnew.Append("     and '" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' ");
                }
                //sbnew.Append(" and  pe.TransactionID= IF(IFNULL(" + Util.GetInt(EncounterNo) + ",0)=0,pe.TransactionID," + Util.GetInt(EncounterNo) + ")  ");

                if (EncounterNo != "")
                {
                    sbnew.Append(" and  pe.TransactionID= '" + EncounterNo + "'  ");
                }
                if (!string.IsNullOrEmpty(CentreId) && CentreId != "All")
                {
                    sbnew.Append(" and   pm.`CentreID`= '" + CentreId + "' ");

                }
                 
                sbnew.Append(" )t ");
            }

                sbnew.Append(" Union All ");
                sbnew.Append(" SELECT * FROM( ");
                sbnew.Append(" SELECT  cm.`CentreName`,0 IsPhoneConsultation,'Emergency' Typ ,CONCAT(pm.Title,' ',pm.PName)NAME,pm.Age,pm.Gender Sex, pe.EmergencyNo EncounterNo, ");
                sbnew.Append(" pe.TransactionID  EncounterId,pe.PatientID PatientId,DATE_FORMAT( pe.EnteredOn ,'%d-%b-%Y' )EntryDate,  ");
                sbnew.Append("  pe.Ispatientreceived STATUS,pm.PanelID PanelId ");
                sbnew.Append(" FROM Emergency_Patient_Details pe ");
                sbnew.Append(" INNER JOIN patient_master pm ON pm.PatientID=pe.PatientId ");
                sbnew.Append(" INNER JOIN center_master cm  ON cm.CentreID=pm.CentreID ");
                 
                sbnew.Append(" WHERE  pe.PatientId= if(ifnull('" + PatientId + "','')='',pe.PatientId,'" + PatientId + "')    ");
                if (chkDate != "0")
                {
                    sbnew.Append(" and  DATE(pe.EnteredOn) between '" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' ");
                    sbnew.Append("     and '" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' ");
                }
                // sbnew.Append(" and  pe.EmergencyNo= IF(IFNULL('" + EncounterNo.Trim() + "','')='',pe.EmergencyNo,'" + EncounterNo.Trim() + "')  ");
                if (EncounterNo != "")
                {
                    sbnew.Append(" and  pe.EmergencyNo= '" + EncounterNo + "'  ");
                }
                if (!string.IsNullOrEmpty(CentreId) && CentreId != "All")
                {
                    sbnew.Append(" and   pm.`CentreID`= '" + CentreId + "' ");

                }

                sbnew.Append(" )t ");
            }
            else
            {
                sbnew = new StringBuilder();
                sbnew.Append(" SELECT * FROM( ");
                sbnew.Append(" SELECT  cm.`CentreName`, 0 IsPhoneConsultation,'Emergency' Typ ,CONCAT(pm.Title,' ',pm.PName)NAME,pm.Age,pm.Gender Sex, pe.EmergencyNo EncounterNo, ");
                sbnew.Append(" pe.TransactionID  EncounterId,pe.PatientID PatientId,DATE_FORMAT( pe.EnteredOn ,'%d-%b-%Y' )EntryDate,  ");
                sbnew.Append("  pe.Ispatientreceived STATUS,pm.PanelID PanelId ");
                sbnew.Append(" FROM Emergency_Patient_Details pe ");
                sbnew.Append(" INNER JOIN patient_master pm ON pm.PatientID=pe.PatientId ");
                sbnew.Append(" INNER JOIN center_master cm  ON cm.CentreID=pm.CentreID ");
                 
                sbnew.Append(" WHERE  pe.PatientId= if(ifnull('" + PatientId + "','')='',pe.PatientId,'" + PatientId + "')    ");
                if (chkDate != "")
                {
                    sbnew.Append(" and  DATE(pe.EnteredOn) between '" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' ");
                    sbnew.Append("     and '" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' ");
                }
               // sbnew.Append(" and  pe.EmergencyNo= IF(IFNULL('" + EncounterNo.Trim() + "','')='',pe.EmergencyNo,'" + EncounterNo.Trim() + "')  ");
                if (EncounterNo != "")
                {
                    sbnew.Append(" and  pe.EmergencyNo= '" + EncounterNo + "'  ");
                }
                if (!string.IsNullOrEmpty(CentreId) && CentreId != "All")
                {
                    sbnew.Append(" and   pm.`CentreID`= '" + CentreId + "' ");

                }

                sbnew.Append(" )t ");
            }
             
            DataTable dt = StockReports.GetDataTable(sbnew.ToString());
            if (dt.Rows.Count > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new
                {
                    status = true,
                    data = dt
                });

            }
            else
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new
                {
                    status = false,
                    data = "No data found."
                });
            }

        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            string st =ex.ToString();
            if (ex.ToString().Contains("Input string was not in a correct format"))
            {
                st = "Checked Is Emergency No.(In case of Emergency Search)";
            }

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, data = st });

        }
    }


    [WebMethod(EnableSession = true)]
    public static string GetDataDetails(string EncounterNo)
    {

        try
        {
            StringBuilder sbnew = new StringBuilder(); 

            sbnew.Append(" SELECT pe.EncounterNo,DATE_FORMAT( pe.DateTime,'%d-%b-%Y') AS EncounterDate,sm.NAME SeviceHead, ");
            sbnew.Append(" im.TypeName ServiceName,pnlm.Company_Name PanelName ,pe.PatientID, ");
            sbnew.Append(" pe.ID EncounterId,lt.TransactionID, ");
            sbnew.Append(" lt.BillNo,ltd.LedgerTransactionNo,ltd.DoctorID, ");
            sbnew.Append(" cm.CategoryID,sm.SubCategoryID,cm.NAME CategoryName ");
            sbnew.Append(" FROM patient_encounter pe "); 
            sbnew.Append(" INNER JOIN  f_ledgertransaction lt ON lt.EncounterNo=pe.EncounterNo ");
            sbnew.Append(" INNER JOIN patient_medical_history  pmh ON pmh.TransactionID=lt.TransactionID AND pmh.TYPE='OPD' ");
            sbnew.Append(" INNER JOIN  f_ledgertnxdetail ltd ON ltd.TransactionID =lt.TransactionID ");
            sbnew.Append(" INNER JOIN f_itemmaster im ON im.ItemID=ltd.ItemID  ");
            sbnew.Append(" INNER JOIN f_subcategorymaster sm ON sm.SubCategoryID=im.SubcategoryID ");
            sbnew.Append(" INNER JOIN f_categorymaster cm ON cm.CategoryID=sm.CategoryID ");
            sbnew.Append(" INNER JOIN  f_panel_master pnlm ON pnlm.PanelID=lt.PanelID  ");
            sbnew.Append(" WHERE pe.EncounterNo="+Util.GetInt(EncounterNo)+" ");
            

            DataTable dt = StockReports.GetDataTable(sbnew.ToString());
            if (dt.Rows.Count > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new
                {
                    status = true,
                    data = dt
                });

            }
            else
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new
                {
                    status = false,
                    data = "No data found."
                });
            }

        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, data = ex.ToString() });

        }
    }



    public void BindCentre()
    {

        string sql = "select CentreID,CentreName from center_master Where IsActive=1 order by CentreName ";
        DataTable dt = StockReports.GetDataTable(sql);

        if (dt.Rows.Count > 0)
        {
            ddlCentre.DataSource = dt;
            ddlCentre.DataTextField = "CentreName";
            ddlCentre.DataValueField = "CentreID";
            ddlCentre.DataBind();
            ddlCentre.Items.Insert(0, "All");
        }
        else
        {
            ddlCentre.Items.Clear();
            ddlCentre.DataSource = null;
            ddlCentre.DataBind();
        }

    }



}