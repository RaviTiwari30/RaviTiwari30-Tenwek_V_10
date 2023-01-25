using System;
using System.Data;
using System.IO;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_OT_Ot_Anaes_PacuOrders : System.Web.UI.Page
{
    public string RoleID;
    protected void Page_Load(object sender, EventArgs e)
    {       
        if (!IsPostBack)
        {
            RoleID = Session["RoleID"].ToString();
            Transaction_ID.Text = Request.QueryString["TransactionID"].ToString();
            PatientId.Text = Request.QueryString["PatientId"].ToString();
            ViewState["UserID"] = Session["ID"].ToString();
            BindData(Transaction_ID.Text.ToString(), PatientId.Text.ToString());
            
            /* Save Button should be display only in OT module. */
            if (RoleID != "213")
               btnSave.Visible = true;
            else
               btnSave.Visible = false;          
        }
    }
    protected void BindData(string TnxID, string PnxID)
    {
        try
        {
            DataTable dtdetail = StockReports.GetDataTable(" SELECT * FROM Cocoa_Anaes_PacuOrders  WHERE Transaction_ID='" + Transaction_ID.Text + "' AND Isactive=1 ");
            if (dtdetail.Rows.Count > 0)
            {
                txtSpecialOrders.Text = dtdetail.Rows[0]["SpecialOrders"].ToString();
                txtComplications.Text = dtdetail.Rows[0]["Complications"].ToString();
                hdnddlAnaesthist.Value = dtdetail.Rows[0]["AnaesthetistID"].ToString();
                txtIntraOPIncidents.Text = dtdetail.Rows[0]["IntraOPIncidents"].ToString();
                txtAdditionalDoctors.Text = dtdetail.Rows[0]["AdditionalDoctors"].ToString();
                if (RoleID != "111")
                {
                    btnSave.Visible = false;
                }
                else
                {
                    btnSave.Text = "Update";
                }
            }
            else
            {
                btnSave.Text = "Save";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);            
        }
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {   
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int ChkEntery = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) FROM Cocoa_Anaes_PacuOrders WHERE Transaction_ID='" + Transaction_ID.Text + "' AND IsActive = 1 "));
            if (ChkEntery > 0)
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update Cocoa_Anaes_PacuOrders set IsActive=0, UpdateBy='" + ViewState["UserID"] + "', UpdateDate='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "' WHERE Transaction_ID='" + Transaction_ID.Text + "' ");
            }

            StringBuilder sb = new StringBuilder();
            sb.Append(" INSERT INTO Cocoa_Anaes_PacuOrders(Patient_ID,Transaction_ID,SpecialOrders,Complications,AnaesthetistID,IntraOPIncidents, ");
            sb.Append(" EntryDate,EntryBy,AdditionalDoctors)");
            sb.Append(" VALUES ('" + PatientId.Text + "','" + Transaction_ID.Text + "','" + txtSpecialOrders.Text + "', '" + txtComplications.Text + "', '" + hdnddlAnaesthist.Value + "', ");
            sb.Append(" '" + txtIntraOPIncidents.Text.Trim().ToString() + "','" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "','" + ViewState["UserID"] + "','" + txtAdditionalDoctors.Text + "')");

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
            tnx.Commit();
            BindData(Transaction_ID.Text.ToString(), PatientId.Text.ToString());           
            lblMsg.Text = "Record Saved Successfully";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
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
}