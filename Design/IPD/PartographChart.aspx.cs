using MySql.Data.MySqlClient;

using System;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Web.Script;
using System.Data;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Linq;
using System.Web.UI.DataVisualization.Charting;
using System.Web.Services;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Collections.Generic;


public partial class Design_IPD_PartographChart : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (!IsPostBack)
            {
                string folderName = @"c:\TempImageFiles";
                string TID = string.Empty;
                if (!Directory.Exists(folderName))
                {
                    Directory.CreateDirectory(folderName);
                }
                if (Request.QueryString["Transaction_ID"] != null)
                {
                    TID = Request.QueryString["Transaction_ID"].ToString();
                    ViewState["Transaction_ID"] = TID;
                }
                else
                {
                    TID = Request.QueryString["TID"].ToString();
                    ViewState["Transaction_ID"] = TID;
                }

                ViewState["IPDNO"] = "";
                ViewState["EMGNo"] = "";
                if (TID.Contains("ISHHI"))
                    ViewState["IPDNO"] = TID.Replace("ISHHI", "");
               // else
               //     ViewState["EMGNo"] = Request.QueryString["EMGNo"].ToString();

                if (Request.QueryString["PID"] != null)
                {
                    ViewState["PID"] = Request.QueryString["PID"].ToString();

                }
                if (Request.QueryString["TransactionID"] != null)
                {
                    string TID1 = Request.QueryString["TransactionID"].ToString();
                    ViewState["TID"] = TID1;
                }
                grdPartographbind();
            }
            txtDeliveryBy.Attributes.Add("readOnly", "readOnly");
       
        }
        catch (Exception ex)
        {
            ClassLog log = new ClassLog();
            log.errLog(ex);
        }
    }
    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection(Util.GetConString());
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            string str = " UPDATE SummaryLabour SET DATE='" + Util.GetDateTime(DateTime.Now).ToString("yyyy-MM-dd") + "',TIME='" + Util.GetDateTime(DateTime.Now).ToString("HH:mm") + "', ";
      str+="UpdatedBy='" + Session["ID"].ToString() + "',UpdateDate='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm::ss") + "',";
            str += "   Induction='" + rdbInduction.SelectedValue + "',Duration='" + txtDuration.Text + "',NoOfVE='" + txtNoOfVE.Text + "',Hours='" + txtHours.Text + "',";
            str += "Mins='" + txtMins.Text + "',Mode1='" + txtModeOfDelivery.Text + "',Duration1='" + txtDutation1.Text + "',AMTSL='" + rdbAMTSL.SelectedValue + "',Uterotonic='" + txtUterotonic.Text + "',";
            str += "Alive='" + rdbAlive.SelectedValue + "',M='" + rdbM.SelectedValue + "',ApgarScore1Min='" + txtApgarScore1Min.Text + "',ApgarScore5Min='" + txtApgarScore5Min.Text + "',";
            str += "ApgarScore10Min='" + txtApgarScore10Min.Text + "',Resusation='" + rdbResusation.SelectedValue + "',Duration3='" + txtDuration3.Text + "',";
            str += "Placenta='" + rdbPlacenta.SelectedValue + "',Membranes='" + rdbMembranes.SelectedValue + "',Cord='" + rdbCord.SelectedValue + "',PlacentaWt='" + txtPlacentaWt.Text + "',EstBloodLoss='" + txtEstBloodLoss.Text + "',";
            str += "Devinial='" + rdbDevinial.SelectedValue + "',BP='" + txtBP1.Text + "',Pulse='" + txtPulse1.Text + "',Temp='" + txtTemp1.Text + "',Resp='" + txtResp1.Text + "',Length1='" + txtLength.Text + "',";
            str += "Weight='" + txtWeight.Text + "',HC='" + txtHC.Text + "',DrugsGiven='" + txtDrugsGiven.Text + "'";
            str += " WHERE ID='" + lblID.Text + "' ";

            int result = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);

            if (result == 1)
            {
                // ScriptManager.RegisterStartupScript(this, this.GetType(), "keySave", "modelAlert('Record Updated Successfully');", true);
                System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Record Updated Successfully');", true);
                tnx.Commit();
                grdPartographbind();
                //Clear();
            }

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        try
        {

           
            string str = "insert into SummaryLabour (PatientID,TransactionID,Date,Time,CreatedBy,CreatedDate, " +
                "Induction,  Duration,  NoOfVE,  Hours,  Mins,  Mode1,  Duration1,  AMTSL,  Uterotonic,  Duration2,  Alive,  M,  ApgarScore1Min,  ApgarScore5Min,  ApgarScore10Min," +
                "  Resusation,  Duration3,  Placenta,  Membranes,  Cord,  PlacentaWt, EstBloodLoss,  Devinial,  BP,  Pulse,  Temp,  Resp,  Length1,  Weight,  HC,  DrugsGiven,  DeliveryBy)"
                      + " Values ('" + Util.GetString(ViewState["PID"]).Trim() + "','" + Util.GetString(ViewState["TID"]).Trim() + "','" + 
                      Util.GetDateTime(DateTime.Now).ToString("yyyy-MM-dd") + "','" + DateTime.Now.ToString("HH:mm") + 
                      "','" + Session["ID"].ToString() + "','" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "'," +
            "'" + rdbInduction.SelectedValue + "','" + txtDuration.Text + "','" + txtNoOfVE.Text + "','" + txtHours.Text + "','" + txtMins.Text + "','" + txtModeOfDelivery.Text + "','" + txtDutation1.Text + "'," +
            "'" + rdbAMTSL.SelectedValue + "','" + txtUterotonic.Text + "','" + txtDurationOfThirdStage.Text + "','" + rdbAlive.SelectedValue + "','" + rdbM.SelectedValue + "','" + txtApgarScore1Min.Text + "'," +
            "'" + txtApgarScore5Min.Text + "','" + txtApgarScore10Min.Text + "','" + rdbResusation.SelectedValue + "','" + txtDuration3.Text + "','" + rdbPlacenta.SelectedValue + "','" + rdbMembranes.SelectedValue + "'," +
            "'" + rdbCord.SelectedValue + "','" + txtPlacentaWt.Text + "','" + txtEstBloodLoss.Text + "','" + rdbDevinial.SelectedValue + "','" + txtBP1.Text + "','" + txtPulse1.Text + "','" + txtTemp1.Text + "'," +
           "'" + txtResp1.Text + "','" + txtLength.Text + "','" + txtWeight.Text + "','" + txtHC.Text + "','" + txtDrugsGiven.Text + "','" + HttpContext.Current.Session["ID"].ToString() + "' )";

            StockReports.ExecuteDML(str);

            
           // ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Record Saved Successfully');", true);
            System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), "keySave", "modelAlert('Record Saved Successfully');", true);
            grdPartographbind();
           // Clear();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblMsg.Text = "Error Occurred. Contact to Administrator.";
            // ScriptManager.RegisterStartupScript(this, this.GetType(), "keySave", "modelAlert('Error Occurred. Contact to Administrator.');", true);
        }
    }
    private DataTable Search()
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT ipo.*, DATE_FORMAT(ipo.Date,'%d-%b-%Y')Date1,TIME_FORMAT(ipo.Time,'%h:%i %p')Time1,ipo.ID, ipo.Induction,  ipo.Duration,  ipo.NoOfVE,  ipo.Hours,  ipo.Mins,  ipo.Mode1,  ipo.Duration1,  ipo.mins1,  ipo.AMTSL,  ipo.Uterotonic, ipo.Duration2,  ipo.Alive,  ipo.M," +
"  ipo.ApgarScore1Min, ipo.ApgarScore5Min,  ipo.ApgarScore10Min,  ipo.Resusation,  ipo.Duration3,  ipo.Mins3, ipo.Placenta,  ipo.Membranes, ipo.Cord,  ipo.PlacentaWt, ipo.EstBloodLoss,  ipo.Devinial," +
"  ipo.BP,  ipo.Pulse,  ipo.Temp,  ipo.Resp,  ipo.Length1,  ipo.Weight, ipo.HC,  ipo.DrugsGiven, (SELECT CONCAT(title,' ',NAME) FROM Employee_master WHERE EmployeeID= ipo.DeliveryBy)DeliveryBy1, (SELECT CONCAT(title,' ',NAME) FROM Employee_master WHERE EmployeeID= ipo.UpdatedBy)UpdatedBy1, (SELECT CONCAT(title,' ',NAME) FROM Employee_master WHERE EmployeeID= ipo.CreatedBy)CreatedBy1 ");
        sb.Append(" FROM SummaryLabour ipo  ");

        sb.Append(" LEFT JOIN employee_master em ON em.employeeID = ipo.CreatedBy  ");
        sb.Append(" WHERE ipo.transactionID = '" + ViewState["Transaction_ID"] + "' GROUP BY ipo.ID ORDER BY ipo.Date DESC,ipo.Time DESC  ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        return dt;
    }
   
    public void grdPartographbind()
    {
        DataTable dt = Search();
       
        if (dt.Rows.Count > 0)
        {
            lblID.Text = dt.Rows[0]["ID"].ToString();
            if (dt.Rows[0]["UpdatedBy"] == DBNull.Value)
            {
                lblLastUpdatedBy.Text = dt.Rows[0]["CreatedBy1"].ToString();
            }
            else
            {

                lblLastUpdatedBy.Text = dt.Rows[0]["UpdatedBy1"].ToString();
            }
            lblLastUpdateDate.Text = dt.Rows[0]["Date1"].ToString() + " " + dt.Rows[0]["Time1"].ToString();
            rdbInduction.SelectedValue = dt.Rows[0]["Induction"].ToString();
            txtDuration.Text = dt.Rows[0]["Duration"].ToString();
            txtNoOfVE.Text = dt.Rows[0]["NoOfVE"].ToString();
            txtHours.Text = dt.Rows[0]["Hours"].ToString();
            txtMins.Text = dt.Rows[0]["Mins"].ToString();
            txtModeOfDelivery.Text = dt.Rows[0]["Mode1"].ToString();
            txtDutation1.Text = dt.Rows[0]["Duration1"].ToString();
            //txtMins1.Text = dt.Rows[0]["mins1"].ToString();
            rdbAMTSL.SelectedValue = dt.Rows[0]["AMTSL"].ToString();
            txtUterotonic.Text = dt.Rows[0]["Uterotonic"].ToString();
            txtDurationOfThirdStage.Text = dt.Rows[0]["Duration2"].ToString();
            rdbAlive.SelectedValue = dt.Rows[0]["Alive"].ToString();
            rdbM.SelectedValue = dt.Rows[0]["M"].ToString();
            txtApgarScore1Min.Text = dt.Rows[0]["ApgarScore1Min"].ToString();
            txtApgarScore5Min.Text = dt.Rows[0]["ApgarScore5Min"].ToString();
            txtApgarScore10Min.Text = dt.Rows[0]["ApgarScore10Min"].ToString();
            rdbResusation.SelectedValue = dt.Rows[0]["Resusation"].ToString();
            txtDuration3.Text = dt.Rows[0]["Duration3"].ToString();
            // txtMins3.Text = dt.Rows[0]["Mins3"].ToString();
            rdbPlacenta.SelectedValue = dt.Rows[0]["Placenta"].ToString();
            rdbMembranes.SelectedValue = dt.Rows[0]["Membranes"].ToString();
            rdbCord.SelectedValue = dt.Rows[0]["Cord"].ToString();
            txtPlacentaWt.Text = dt.Rows[0]["PlacentaWt"].ToString();
            txtEstBloodLoss.Text = dt.Rows[0]["EstBloodLoss"].ToString();
            rdbDevinial.SelectedValue = dt.Rows[0]["Devinial"].ToString();
            txtBP1.Text = dt.Rows[0]["BP"].ToString();
            txtPulse1.Text = dt.Rows[0]["Pulse"].ToString();
            txtTemp1.Text = dt.Rows[0]["Temp"].ToString();
            txtResp1.Text = dt.Rows[0]["Resp"].ToString();
            txtLength.Text = dt.Rows[0]["Length1"].ToString();
            txtHC.Text = dt.Rows[0]["HC"].ToString();
            txtDrugsGiven.Text = dt.Rows[0]["DrugsGiven"].ToString();
            txtDeliveryBy.Text = dt.Rows[0]["DeliveryBy1"].ToString();
            Btnsave.Visible = false;
            btnUpdate.Visible = true;
        }
    }


    [WebMethod]
    public static string BindFHR_graph(string TID)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT CONCAT(DATE_FORMAT(pgh.CreatedDate,'%d-%b-%Y'),' ',DATE_FORMAT(pgh.CreatedDate,'%h:%i %p')) AS CreatedTime,(FHR+0)FHR ");
        sb.Append(" FROM ipd_patient_partograph pgh  ");
        sb.Append(" WHERE pgh.TransactionID='" + TID + "' AND FHR<>''  ORDER BY DATE(CreatedDate),TIME(CreatedDate) ");       

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }

    [WebMethod]
    public static string bindCervixDescent_graph(string TID)
    {
        StringBuilder sb = new StringBuilder();
        // sb.Append(" SELECT CONCAT(DATE_FORMAT(EntDate,'%d-%b-%Y'),' ',TIME_FORMAT(EntTime,'%h:%i %p')) AS CreatedTime,");
        sb.Append(" SELECT TIME_FORMAT(EntTime,'%h:%i %p') AS CreatedTime,");
        sb.Append(" Cervix, IF(Descent='Select',0,Descent)Descent, Alert, Action  ");
        sb.Append(" FROM ipd_patient_partograph_CervixDescent WHERE TransactionID='" + TID + "' AND Cervix<>'Select' ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }

    [WebMethod]
    public static string bindContractions_graph(string TID)
    {       
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT t.* FROM ( ");
        sb.Append(" SELECT CONCAT(DATE_FORMAT(CreatedDate,'%d-%b-%Y'),' ',DATE_FORMAT(CreatedDate,'%h:%i %p')) AS CreatedTime,Lasting, ");
        sb.Append(" (Contractions+0)_20sec,0 _20_40sec,0 _40sec  ");
        sb.Append(" FROM ipd_patient_partograph WHERE TransactionID='" + TID + "' AND Lasting='< 20 secs' ");
        sb.Append("  UNION ALL  ");
        sb.Append(" SELECT CONCAT(DATE_FORMAT(CreatedDate,'%d-%b-%Y'),' ',DATE_FORMAT(CreatedDate,'%h:%i %p')) AS CreatedTime,Lasting, ");
        sb.Append(" 0 _20sec,(Contractions+0)_20_40sec,0 _40sec ");
        sb.Append(" FROM ipd_patient_partograph WHERE TransactionID='" + TID + "' AND Lasting='20 to 40' ");
        sb.Append("  UNION ALL  ");
        sb.Append(" SELECT CONCAT(DATE_FORMAT(CreatedDate,'%d-%b-%Y'),' ',DATE_FORMAT(CreatedDate,'%h:%i %p')) AS CreatedTime,Lasting, ");
        sb.Append(" 0 _20sec,0 _20_40sec,(Contractions+0)_40sec ");
        sb.Append(" FROM ipd_patient_partograph WHERE TransactionID='" + TID + "' AND Lasting='> 40' ");
        sb.Append(" ) t ORDER BY t.CreatedTime asc "); 

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }
}