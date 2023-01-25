using System;
using System.IO;

public partial class Document_downloads : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if(!IsPostBack)
        {
            lblMsg.Text = "";
        }
    }
    protected void LoadFile(string FileName)
    {
        lblMsg.Text = "";
        string Path = "~/Documents";
        bool IsExists = System.IO.Directory.Exists(Server.MapPath(Path));
        if (!IsExists)
        {
            System.IO.Directory.CreateDirectory(Server.MapPath(Path));
        }
        string url = Server.MapPath("~/Documents/" + FileName + ".pdf");
        if (File.Exists(url))
        {
            lblMsg.Text = "";
            Response.AddHeader("content-disposition", @"attachment; filename=" + FileName + ".pdf");
            Response.ContentType = "application/pdf";
            Response.WriteFile(url);
            Response.End();
        }
        else
        {
            lblMsg.Text = "File Not Available";
            return;
        }
    }
    protected void lnkOPD_Click(object sender, EventArgs e)
    {
        LoadFile("UserManual-OPD");
    }
    protected void lnkCPOE_Click(object sender, EventArgs e)
    {
        LoadFile("UserManual-CPOE");
    }
    protected void lnkPharmacy_Click(object sender, EventArgs e)
    {
        LoadFile("UserManual-Pharmacy");
    }
    protected void lnkMedical_Click(object sender, EventArgs e)
    {
        LoadFile("UserManual-MedicalStore");
    }
    protected void lnkGeneral_Click(object sender, EventArgs e)
    {
        LoadFile("UserManual-GeneralStore");
    }
    protected void lnkPurchase_Click(object sender, EventArgs e)
    {
        LoadFile("UserManual-Purchase");
    }
    protected void lnkBilling_Click(object sender, EventArgs e)
    {
        LoadFile("UserManual-Billing");
    }
    protected void lnkLaboratory_Click(object sender, EventArgs e)
    {
        LoadFile("UserManual-Laboratory");
    }
    protected void lnkRadiology_Click(object sender, EventArgs e)
    {
        LoadFile("UserManual-Radiology");
    }
    protected void lnkMRD_Click(object sender, EventArgs e)
    {
        LoadFile("UserManual-MRD");
    }
    protected void lnkPayroll_Click(object sender, EventArgs e)
    {
        LoadFile("UserManual-Payroll");
    }
    protected void lnkHR_Click(object sender, EventArgs e)
    {
        LoadFile("UserManual-HR");
    }
    protected void lnkMIS_Click(object sender, EventArgs e)
    {
        LoadFile("UserManual-MIS");
    }
    protected void lnkAdmissionDischarge_Click(object sender, EventArgs e)
    {
        LoadFile("UserManual-AdmissionDischarge");
    }
    protected void lnkEMR_Click(object sender, EventArgs e)
    {
        LoadFile("UserManual-EMR");
    }
    protected void lnkEDP_Click(object sender, EventArgs e)
    {
        LoadFile("UserManual-EDP");
    }
    protected void lnkNursing_Click(object sender, EventArgs e)
    {
        LoadFile("UserManual-Nursing");
    }
    protected void lnkBloodBank_Click(object sender, EventArgs e)
    {
        LoadFile("UserManual-BloodBank");
    }
    protected void lnkCSSD_Click(object sender, EventArgs e)
    {
        LoadFile("UserManual-CSSD");
    }
    protected void imgVideo_Click(object sender, System.Web.UI.ImageClickEventArgs e)
    {
        DownloadVideo("OPD");
    }

    private void DownloadVideo(string VideoFileName)
    {
        lblMsg.Text = "";

        string url = "C:\\Video\\" + VideoFileName + ".mp4";

        Response.Write(url);
        lblMsg.Text = "";
        Response.AddHeader("content-disposition", @"attachment; filename=" + VideoFileName + ".mp4");
        //Response.ContentType = "application/mp4";
        Response.WriteFile(url);
        Response.End();
        
    }
}