using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;

public partial class Design_Dispatch_PanelwiseCoverNoteMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
       
    }

    [WebMethod]
    public static string bindDoctorTabs(string doctorId, string RoleID)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("  SELECT cp.`AccordianName`,cp.Id,cpms.IsDefaultCheck   ");
        sb.Append("  FROM  cpoe_prescription_master cp  ");
        sb.Append("  INNER JOIN cpoe_prescription_master_Setting cpms ON cp.`ID`=cpms.`CPOE_Prescription_Master_ID`  ");
        sb.Append("  WHERE cpms.`RoleID`='" + RoleID + "' AND cp.IsActive=1 AND cpms.`IsActive`=1 AND cpms.`IsDefault`=0  ");
        sb.Append("  AND cpms.`DoctorID`='" + doctorId + "' GROUP BY cp.`ID` ");
        sb.Append("  ORDER BY cpms.order+0 ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }

    [WebMethod]
    public static string bindCoverNoteColumnsDetail(int isCoverNote)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("  SELECT c.`ID`,c.`FieldName`,c.IsBillDetailColumn FROM master_CoverNoteFields c WHERE c.`IsActive`=1 and c.isCoverNote IN(" + isCoverNote + ",2) ORDER BY c.IsBillDetailColumn,c.`FieldName` ASC ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }
     [WebMethod]
    public static string bindOldContent(int PanelID, int CentreID, int PatientTypeID,int FormatType)
    {
       ExcuteCMD excuteCMD = new ExcuteCMD();
       DataTable dt = excuteCMD.GetDataTable(" SELECT IsCentreLogo,IFNULL(HeaderText,'') AS HeaderText, IFNULL(BodyContent,'') AS BodyContent,IFNULL(BillGridColumns,'') AS BillGridColumns FROM CoverNoteFormat_Master WHERE CentreID=@centreID AND PanelID=@panelID AND PatientType=@patientType AND IsActive=1 AND isCoverNote=@IsCoverNote", CommandType.Text, new
        {
            centreID = CentreID,
            panelID = PanelID,
            patientType = PatientTypeID,
            IsCoverNote= FormatType
        });

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }

    [WebMethod(EnableSession = true)]
    public static string SaveCoverNoteMaster(string CoverNoteBodyContent, int PanelID, int CentreID, int PatientTypeID, string BillGridColumns,string ShowHeader,string HeaderText,int FormatType)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            excuteCMD.DML(tnx, "UPDATE CoverNoteFormat_Master SET IsActive=0,UpdatedBy=@CreatedBy,UpdatedDateTime=NOW() WHERE CentreID=@centreID AND PanelID=@panelID AND PatientType=@patientType AND IsActive=1 AND isCoverNote=@isCoverNote", CommandType.Text, new
                {
                    centreID = CentreID,
                    panelID = PanelID,
                    patientType = PatientTypeID,
                    CreatedBy = HttpContext.Current.Session["ID"].ToString(),
                    isCoverNote = FormatType
                });

            excuteCMD.DML(tnx, "INSERT INTO CoverNoteFormat_Master(CentreID,PanelID,PatientType,BodyContent,BillGridColumns,CreatedBy,CreatedDateTime,IsCentreLogo,HeaderText,isCoverNote) VALUES(@centreID, @panelID, @patientType, @BodyContent, @billGridColumns, @CreatedBy, NOW(), @IsCentreLogo, @headerText,@isCoverNote) ", CommandType.Text, new
                {
                    centreID = CentreID,
                    panelID = PanelID,
                    patientType = PatientTypeID,
                    BodyContent = CoverNoteBodyContent,
                    billGridColumns = BillGridColumns,
                    CreatedBy = HttpContext.Current.Session["ID"].ToString(),
                    IsCentreLogo = ShowHeader,
                    headerText = HeaderText,
                    isCoverNote= FormatType
                });

          int MaxID = Util.GetInt( MySqlHelper.ExecuteScalar(tnx,CommandType.Text,"Select MAX(ID) from CoverNoteFormat_Master"));
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage, currentEntryID = MaxID });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }

    public class panel
    {
        public int panelID { get; set; }
    }

    [WebMethod(EnableSession = true)]
    public static string CopyCoverNoteFormat(int currentEntryID, int CentreID, int PatientTypeID, List<panel> panelList, int FormatType)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            for (int k = 0; k < panelList.Count; k++)
            {
                excuteCMD.DML(tnx, "UPDATE CoverNoteFormat_Master SET IsActive=0,UpdatedBy=@CreatedBy,UpdatedDateTime=NOW() WHERE CentreID=@centreID AND PanelID=@panelID AND PatientType=@patientType AND IsActive=1 AND isCoverNote=@isCoverNote", CommandType.Text, new
                {
                    centreID = CentreID,
                    panelID = panelList[k].panelID,
                    patientType = PatientTypeID,
                    CreatedBy = HttpContext.Current.Session["ID"].ToString(),
                    isCoverNote = FormatType
                });

                excuteCMD.DML(tnx, "INSERT INTO CoverNoteFormat_Master(CentreID,PanelID,PatientType,BodyContent,BillGridColumns,CreatedBy,CreatedDateTime,IsCentreLogo,HeaderText,isCoverNote) SELECT f.`CentreID`,@panelID,f.`PatientType`, f.`BodyContent`,f.`BillGridColumns`,@CreatedBy,NOW(),f.IsCentreLogo,f.HeaderText,f.isCoverNote FROM CoverNoteFormat_Master f WHERE f.`ID`=@CurrentEntryID  ", CommandType.Text, new
                {
                    panelID = panelList[k].panelID,
                    CurrentEntryID = currentEntryID,
                    CreatedBy = HttpContext.Current.Session["ID"].ToString()
                });

            }
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = AllGlobalFunction.saveMessage });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }
}