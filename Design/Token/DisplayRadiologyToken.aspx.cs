using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Text;
using System.Data;

public partial class Design_Token_DisplayRadiologyToken : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod]
    public static string DisplayTokenList(string DepartmentID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT rcn.TokenNo,rcn.Type,CONCAT(PM.Title,' ',Pm.PName)pname,ot.Name DepartmentName,im.Name AS InvestigationName,rcn.TokenCreateTime,ot.ObservationType_ID AS DeptId ");
        sb.Append(" FROM Radiolody_CreateToken_Number rcn INNER JOIN patient_master PM ON PM.PatientID = rcn.PatientID ");
        sb.Append(" INNER JOIN observationtype_master ot ON ot.ObservationType_ID = rcn.ObservationType_Id ");
        sb.Append(" INNER JOIN investigation_master IM ON IM.Investigation_Id=rcn.Investigation_Id");
        sb.Append("  INNER JOIN patient_labinvestigation_opd plo ON plo.LabInvestigationOPD_ID=rcn.TestId AND plo.IsSampleCollected<>'Y' ");
        sb.Append(" WHERE rcn.IsCancelToken=0 AND rcn.TockenCreatedDate=CURDATE() and RCN.Type='OPD'  ");
        if (DepartmentID != null && DepartmentID != "")
        {
            sb.Append(" and ot.ObservationType_ID in (" + DepartmentID + ") ");
        }
        sb.Append("  UNION ALL   ");
        sb.Append("  SELECT rcn.TokenNo,rcn.Type,CONCAT(PM.Title,' ',Pm.PName)pname,ot.Name DepartmentName, im.Name AS InvestigationName,rcn.TokenCreateTime,ot.ObservationType_ID AS DeptId ");
        sb.Append("  FROM Radiolody_CreateToken_Number rcn  ");
        sb.Append("  INNER JOIN patient_master PM ON PM.PatientID = rcn.PatientID  INNER JOIN observationtype_master ot ON ot.ObservationType_ID = rcn.ObservationType_Id    ");
        sb.Append(" INNER JOIN investigation_master IM ON IM.Investigation_Id=rcn.Investigation_Id   ");
        sb.Append("  INNER JOIN patient_labinvestigation_Ipd pli ON pli.LabInvestigationIPD_ID=rcn.TestId AND plI.IsSampleCollected<>'Y' ");
        sb.Append("  WHERE rcn.IsCancelToken=0 AND rcn.TockenCreatedDate=CURDATE() AND RCN.Type='IPD'   ");
        if (DepartmentID != null && DepartmentID != "")
        {
            sb.Append(" and ot.ObservationType_ID in (" + DepartmentID + ")");
        }
        sb.Append("  ORDER BY DepartmentName,TokenNo,TokenCreateTime");
     
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
            return "";
    }

}