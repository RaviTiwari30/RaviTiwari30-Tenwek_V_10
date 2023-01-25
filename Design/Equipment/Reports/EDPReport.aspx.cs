using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using CrystalDecisions.CrystalReports.Engine;

public partial class Reports_Forms_EDPReport : System.Web.UI.Page
{
    ReportDocument obj1 = new ReportDocument();
    protected void Page_Load(object sender, EventArgs e)
    {        
        if (Request.QueryString["ReportType"] != null)
        {
            
            DataSet ds = new DataSet();
            ds = (DataSet)Session["EDPReport"];        

            string ReportType = string.Empty;
            ReportType = Request.QueryString["ReportType"];
            
            Session.Remove("EDPReport");
           
            switch (ReportType)
            { 
                
                case "PAA1":
                    obj1.Load(Server.MapPath(@"~/Reports/EDP/PAAdmittedAllPatients.rpt"));
                    break;
                case "PAA2":
                    obj1.Load(Server.MapPath(@"~/Reports/EDP/PAPatientsBedCategoryWise.rpt"));
                    break;
                case "PAA3":
                    obj1.Load(Server.MapPath(@"~/Reports/EDP/PAPatientsConsultantWise.rpt"));
                    break;

                case "PAA4":
                    obj1.Load(Server.MapPath(@"~/Reports/EDP/PAPatientsDateWise.rpt"));
                    break;
                case "PAA5":
                    obj1.Load(Server.MapPath(@"~/Reports/EDP/PAPatientsDeptWise.rpt"));
                    break;
                case "PAA6":
                    obj1.Load(Server.MapPath(@"~/Reports/EDP/PAPatientsFloorWise.rpt"));
                    break;
                case "PAA7":
                    obj1.Load(Server.MapPath(@"~/Reports/EDP/PAPatientsPanelWise.rpt"));
                    break;



                case "AA1" :
                    obj1.Load(Server.MapPath(@"~/Reports/EDP/AAdmittedAllPatients.rpt"));
                    break;
                case "AA2" :
                    obj1.Load(Server.MapPath(@"~/Reports/EDP/APatientsBedCategoryWise.rpt"));
                    break;
                case "AA3" :
                    obj1.Load(Server.MapPath(@"~/Reports/EDP/APatientsConsultantWise.rpt"));
                    break;
                case "AA4" :
                    obj1.Load(Server.MapPath(@"~/Reports/EDP/APatientsDateWise.rpt"));
                    break;
                case "AA5" :
                    obj1.Load(Server.MapPath(@"~/Reports/EDP/APatientsDeptWise.rpt"));
                    break;
                case "AA6" :
                    obj1.Load(Server.MapPath(@"~/Reports/EDP/APatientsFloorWise.rpt"));
                    break;
                case "AA7" :
                    obj1.Load(Server.MapPath(@"~/Reports/EDP/APatientsPanelWise.rpt"));
                    break;
                case "AA8":
                    obj1.Load(Server.MapPath(@"~/Reports/EDP/APatientAdvaceSlip.rpt"));
                    break;


                case "A1":
                    obj1.Load(Server.MapPath(@"~/Reports/EDP/AdmittedAllPatients.rpt"));
                    break;
                case "A2":
                    obj1.Load(Server.MapPath(@"~/Reports/EDP/PatientsBedCategoryWise.rpt"));
                    break;
                case "A3":
                    obj1.Load(Server.MapPath(@"~/Reports/EDP/PatientsConsultantWise.rpt"));
                    break;
                case "A4":
                    obj1.Load(Server.MapPath(@"~/Reports/EDP/PatientsDateWise.rpt"));
                    break;
                case "A5":
                    obj1.Load(Server.MapPath(@"~/Reports/EDP/PatientsDeptWise.rpt"));
                    break;
                case "A6":
                    obj1.Load(Server.MapPath(@"~/Reports/EDP/PatientsFloorWise.rpt"));
                    break;
                case "A7":
                    obj1.Load(Server.MapPath(@"~/Reports/EDP/PatientsPanelWise.rpt"));
                    break;

                case "D1":
                    obj1.Load(Server.MapPath(@"~/Reports/EDP/DischargeAllPatients.rpt"));
                    break;
                case "D2":
                    obj1.Load(Server.MapPath(@"~/Reports/EDP/PatientsDischargeBedCategoryWise.rpt"));
                    break;
                case "D3":
                    obj1.Load(Server.MapPath(@"~/Reports/EDP/PatientsDischargeConsultantWise.rpt"));
                    break;
                case "D4":
                    obj1.Load(Server.MapPath(@"~/Reports/EDP/PatientsDischargeDateWise.rpt"));
                    break;
                case "D5":
                    obj1.Load(Server.MapPath(@"~/Reports/EDP/PatientsDischargeDeptWise.rpt"));
                    break;
                case "D6":
                    obj1.Load(Server.MapPath(@"~/Reports/EDP/PatientsDischargeFloorWise.rpt"));
                    break;
                case "D7":
                    obj1.Load(Server.MapPath(@"~/Reports/EDP/PatientsDischargePanelWise.rpt"));
                    break;
                default :
                    return ;
            
            }                
           
            obj1.SetDataSource(ds);            

            System.IO.MemoryStream m = (System.IO.MemoryStream)obj1.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat);
            obj1.Close();
            obj1.Dispose();
            Response.ClearContent();
            Response.ClearHeaders();
            Response.Buffer = true;
            Response.ContentType = "application/pdf";
            Response.BinaryWrite(m.ToArray());
        }
    }
    protected void Page_UnLoad(object sender, EventArgs e)
    {
        if (obj1 != null)
        {
            obj1.Close();
            obj1.Dispose();
        }
    }


}
