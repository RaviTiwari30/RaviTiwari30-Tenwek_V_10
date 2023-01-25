using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web;
using System.Text;

public partial class Design_IPD_UpdateIPDBillNarration : System.Web.UI.Page
{
   protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
              DataTable dtAuthority = StockReports.GetAuthorization(Util.GetInt(Session["RoleID"]), Util.GetString(Session["ID"]));

              if (dtAuthority.Rows.Count > 0)
              {
                  if (dtAuthority.Rows[0]["CanUpdateBillNarration"].ToString() == "0")
                  {
                       lblMsg.Text = "You Are Not Authorised To Update Bill Narration...";
                       btnView.Visible = false;
                     
                  }
                  else
                  {
                      lblMsg.Text = " ";
                      btnView.Visible = true;
                  }
              }
        }

    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        try
        {
            if (txtTransactionId.Text.Trim() == "")
            {
                lblMsg.Text = "Please Enter IPD NO.";
                txtTransactionId.Focus();
                return;

            }
            string IPDNo = "";
            if (txtTransactionId.Text.Trim() != "")
                IPDNo = StockReports.getTransactionIDbyTransNo(txtTransactionId.Text.Trim());//"" +


            lblMsg.Text = "";
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT IP.BillNo BillNo,IP.TotalBilledAmt,IP.TransactionID,IP.Transno IPDNo ");
            sb.Append(",IP.PatientID,PM.PName,ip.`Narration`,CONCAT(pm.House_No,' ',pm.Street_Name,' ',pm.Locality,',',pm.City)Address,pm.`Mobile`,pm.PatientID,(SELECT Company_Name FROM `f_panel_master` p  WHERE p.`PanelID`=ip.`PanelID` )Company_Name FROM Patient_Medical_History IP ");
            sb.Append(" INNER JOIN patient_master PM ON IP.PatientID=PM.PatientID ");
            sb.Append(" WHERE IFNULL(IP.BillNo,'')<>''  AND IP.TransactionID='" + IPDNo + "' ");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                grdPatient.DataSource = dt;
                grdPatient.DataBind();
            }
            else
            {
                lblMsg.Text = "No Record Found";
                grdPatient.DataSource = null;
                grdPatient.DataBind();
            }


        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }
    protected void grdPatientDetail_SelectedIndexChanged(object sender, EventArgs e)
    {
        Label Narration = (Label)grdPatient.SelectedRow.FindControl("lblNarration");
        txtNarration.Text = Narration.Text;
        mpDetail.Show();
    }
    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.ReadCommitted);

        try
        {
            if (txtNarration.Text.Trim() == "")
            {
                lblMsg.Text = "Please Enter Narration";
                txtNarration.Focus();
                mpDetail.Show();
                return;
            }
            Label IPDNo = (Label)grdPatient.SelectedRow.FindControl("lblTransactionID");
            StringBuilder sbb = new StringBuilder();//
            sbb.Append("UPDATE `Patient_Medical_History` SET Narration='" + txtNarration.Text.Trim() + "',LastUpdatedBy='" + Session["ID"].ToString() + "',Updatedate=NOW() WHERE TransactionID='" + IPDNo.Text + "'");//
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sbb.ToString());//

            Tranx.Commit();
            grdPatient.DataSource = null;
            grdPatient.DataBind();
            mpDetail.Hide();
            txtTransactionId.Text = "";
            lblMsg.Text = "Record Updated Successfully";
        }
        catch (Exception ex)
        {
            lblMsg.Text = "Error occurred, Please contact administrator";
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}
