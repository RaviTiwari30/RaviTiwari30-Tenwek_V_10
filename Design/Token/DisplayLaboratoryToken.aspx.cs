using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Token_DisplayLaboratoryToken : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod]
    public static string DisplayTokenList(string DepartmentID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT CONCAT(PM.Title,' ',Pm.PName)PatientName,otm.Name Department,im.Name AS InvestigationName,pli.TokenNo FROM patient_labinvestigation_opd pli  ");
        sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=pli.LedgerTransactionNo   ");
        sb.Append("INNER JOIN patient_master PM ON pli.PatientID = PM.PatientID AND pli.Result_Flag=0  ");
        sb.Append(" INNER JOIN investigation_master im ON pli.Investigation_ID = im.Investigation_Id AND IM.ReportType IN(1,3)   ");
        sb.Append(" INNER JOIN doctor_master dm  ON dm.DoctorID = PLI.DoctorID ");
        sb.Append(" INNER JOIN investigation_observationtype iom ON iom.Investigation_ID = im.Investigation_ID  ");
        sb.Append(" INNER JOIN observationtype_master otm ON otm.ObservationType_Id = iom.ObservationType_Id  ");
        sb.Append("  WHERE im.Type='R'  AND IsSampleCollected='N' ");
        sb.Append(" AND PLI.Date=CURDATE() AND pli.TockenCreatedDate=CURDATE() AND pli.TokenNo<>'' AND pli.IsCancelToken=0  AND pli.IsSampleCollected<>'Y' ");
        if (DepartmentID != null && DepartmentID != "")
        {
            sb.Append(" and otm.ObservationType_ID in (" + DepartmentID + ")");
        }
        sb.Append(" ORDER BY pli.tokenNo,otm.Name,pli.TokenCreatedTime ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
            return "";
    }
}