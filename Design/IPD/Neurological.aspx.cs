using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

public partial class Design_CPOE_Neurological : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["UserID"] = Session["ID"].ToString();
            ViewState["TransactionID"] = Request.QueryString["TransactionID"].ToString();
            ViewState["PatientID"] = Request.QueryString["PatientID"].ToString();
            ViewState["IsViewable"] = "1";

            lblTransactionID.Text = ViewState["TransactionID"].ToString();

            BindGridDetail();
        }

        lblMsg.Text = "";
    }

    protected void grdNeu_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "AView")
        {
            int ID = Util.GetInt(e.CommandArgument);

            if (ID != 0)
            {
                BindDetails(ID);
            }
        }
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        btnSave.Visible = true;
        btnPrint.Visible = false;
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            //Delete the Old row and add this In case of edit.
            if (lblID.Text != "")
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE FROM cpoe_neurological_analysis WHERE ID=" + Util.GetInt(lblID.Text) + "");
            }

            cpoe_neurological_analysis cpoe_sa = new cpoe_neurological_analysis(tnx);

            for (int i = 0; i < chkNeurologicalExam.Items.Count; i++)
            {
                if (chkNeurologicalExam.Items[i].Selected == true)
                {
                    cpoe_sa.IsNeurologicalExam = Util.GetString(chkNeurologicalExam.Items[i].Text);
                }
            }

            cpoe_sa.MuscleR1 = Util.GetString(txtMuscleR1.Text);
            cpoe_sa.MuscleR2 = Util.GetString(txtMuscleR2.Text);
            cpoe_sa.MuscleR3 = Util.GetString(txtMuscleR3.Text);
            cpoe_sa.MuscleR4 = Util.GetString(txtMuscleR4.Text);
            cpoe_sa.MuscleR5 = Util.GetString(txtMuscleR5.Text);
            cpoe_sa.MuscleR6 = Util.GetString(txtMuscleR6.Text);
            cpoe_sa.MuscleR7 = Util.GetString(txtMuscleR7.Text);
            cpoe_sa.MuscleR8 = Util.GetString(txtMuscleR8.Text);
            cpoe_sa.MuscleR9 = Util.GetString(txtMuscleR9.Text);
            cpoe_sa.MuscleR10 = Util.GetString(txtMuscleR10.Text);
            cpoe_sa.MuscleL1 = Util.GetString(txtMuscleL1.Text);
            cpoe_sa.MuscleL2 = Util.GetString(txtMuscleL2.Text);
            cpoe_sa.MuscleL3 = Util.GetString(txtMuscleL3.Text);
            cpoe_sa.MuscleL4 = Util.GetString(txtMuscleL4.Text);
            cpoe_sa.MuscleL5 = Util.GetString(txtMuscleL5.Text);
            cpoe_sa.MuscleL6 = Util.GetString(txtMuscleL6.Text);
            cpoe_sa.MuscleL7 = Util.GetString(txtMuscleL7.Text);
            cpoe_sa.MuscleL8 = Util.GetString(txtMuscleL8.Text);
            cpoe_sa.MuscleL9 = Util.GetString(txtMuscleL9.Text);
            cpoe_sa.MuscleL10 = Util.GetString(txtMuscleL10.Text);
            cpoe_sa.DermatoneR1 = Util.GetString(txtDermatoneR1.Text);
            cpoe_sa.DermatoneR2 = Util.GetString(txtDermatoneR2.Text);
            cpoe_sa.DermatoneR3 = Util.GetString(txtDermatoneR3.Text);
            cpoe_sa.DermatoneR4 = Util.GetString(txtDermatoneR4.Text);
            cpoe_sa.DermatoneR5 = Util.GetString(txtDermatoneR5.Text);
            cpoe_sa.DermatoneR6 = Util.GetString(txtDermatoneR6.Text);
            cpoe_sa.DermatoneR7 = Util.GetString(txtDermatoneR7.Text);
            cpoe_sa.DermatoneR8 = Util.GetString(txtDermatoneR8.Text);
            cpoe_sa.DermatoneR9 = Util.GetString(txtDermatoneR9.Text);
            cpoe_sa.DermatoneR10 = Util.GetString(txtDermatoneR10.Text);
            cpoe_sa.DermatoneR11 = Util.GetString(txtDermatoneR11.Text);
            cpoe_sa.DermatoneR12 = Util.GetString(txtDermatoneR12.Text);
            cpoe_sa.DermatoneL1 = Util.GetString(txtDermatoneL1.Text);
            cpoe_sa.DermatoneL2 = Util.GetString(txtDermatoneL2.Text);
            cpoe_sa.DermatoneL3 = Util.GetString(txtDermatoneL3.Text);
            cpoe_sa.DermatoneL4 = Util.GetString(txtDermatoneL4.Text);
            cpoe_sa.DermatoneL5 = Util.GetString(txtDermatoneL5.Text);
            cpoe_sa.DermatoneL6 = Util.GetString(txtDermatoneL6.Text);
            cpoe_sa.DermatoneL7 = Util.GetString(txtDermatoneL7.Text);
            cpoe_sa.DermatoneL8 = Util.GetString(txtDermatoneL8.Text);
            cpoe_sa.DermatoneL9 = Util.GetString(txtDermatoneL9.Text);
            cpoe_sa.DermatoneL10 = Util.GetString(txtDermatoneL10.Text);
            cpoe_sa.DermatoneL11 = Util.GetString(txtDermatoneL11.Text);
            cpoe_sa.DermatoneL12 = Util.GetString(txtDermatoneL12.Text);

            for (int i = 0; i < chkSacralRoot.Items.Count; i++)
            {
                if (chkSacralRoot.Items[i].Selected == true)
                {
                    cpoe_sa.IsPersonalsensation = Util.GetString(chkSacralRoot.Items[i].Text);
                }
            }

            for (int i = 0; i < chkSacralRootrectal.Items.Count; i++)
            {
                if (chkSacralRootrectal.Items[i].Selected == true)
                {
                    cpoe_sa.IsRectal = Util.GetString(chkSacralRootrectal.Items[i].Text);
                }
            }

            cpoe_sa.ReflexesR1 = Util.GetString(chkReflexesR1.Text);
            cpoe_sa.ReflexesR2 = Util.GetString(chkReflexesR2.Text);
            cpoe_sa.ReflexesR3 = Util.GetString(chkReflexesR3.Text);
            cpoe_sa.ReflexesR4 = Util.GetString(chkReflexesR4.Text);
            cpoe_sa.ReflexesL1 = Util.GetString(chkReflexesL1.Text);
            cpoe_sa.ReflexesL2 = Util.GetString(chkReflexesL2.Text);
            cpoe_sa.ReflexesL3 = Util.GetString(chkReflexesL3.Text);
            cpoe_sa.ReflexesL4 = Util.GetString(chkReflexesL4.Text);

            for (int i = 0; i < chkAncleclonus.Items.Count; i++)
            {
                if (chkAncleclonus.Items[i].Selected == true)
                {
                    cpoe_sa.IsAnkleClonus = Util.GetString(chkAncleclonus.Items[i].Text);
                }
            }

            for (int i = 0; i < chkAnkleClonusR1.Items.Count; i++)
            {
                if (chkAnkleClonusR1.Items[i].Selected == true)
                {
                    cpoe_sa.IsAnkleClonusR1 = Util.GetString(chkAnkleClonusR1.Items[i].Text);
                }
            }

            for (int i = 0; i < chkAnkleClonusR2.Items.Count; i++)
            {
                if (chkAnkleClonusR2.Items[i].Selected == true)
                {
                    cpoe_sa.IsAnkleClonusR2 = Util.GetString(chkAnkleClonusR2.Items[i].Text);
                }
            }

            for (int i = 0; i < chkAnkleClonusL1.Items.Count; i++)
            {
                if (chkAnkleClonusL1.Items[i].Selected == true)
                {
                    cpoe_sa.IsAnkleClonusL1 = Util.GetString(chkAnkleClonusL1.Items[i].Text);
                }
            }

            for (int i = 0; i < chkAnkleClonusL2.Items.Count; i++)
            {
                if (chkAnkleClonusL2.Items[i].Selected == true)
                {
                    cpoe_sa.IsAnkleClonusL2 = Util.GetString(chkAnkleClonusL2.Items[i].Text);
                }
            }

            cpoe_sa.PatientID = ViewState["PatientID"].ToString();
            cpoe_sa.TransactionID = Util.GetString(ViewState["TransactionID"]);
            cpoe_sa.Note = Util.GetString(txtNote.Text);
            cpoe_sa.CreatedBy = Util.GetString(ViewState["UserID"]);
            cpoe_sa.CreatedDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd hh:mm:ss"));
            cpoe_sa.UpdatedBy = Util.GetString(ViewState["UserID"]);
            cpoe_sa.UpdatedDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd hh:mm:ss"));
            string IsInsert = cpoe_sa.Insert();

            if (IsInsert == "")
            {
                tnx.Rollback();
                return;
            }

            tnx.Commit();

            BindGridDetail();

            lblID.Text = "";
            lblMsg.Text = "Record Saved Successfully";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "key", "refresh();", true);
        }
        catch (Exception ex)
        {
            tnx.Rollback();

            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);

            lblMsg.Text = "Error occurred, Please contact administrator";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    private void BindGridDetail()
    {
        string query = "SELECT cp.ID,DATE_FORMAT(cp.CreatedDate,'%d-%b-%Y %h:%i %p') AS EntryDate,CONCAT(em.Title,' ',em.Name) AS EntryBy,IsNeurologicalExam " +
                       "FROM cpoe_neurological_analysis cp INNER JOIN employee_master em ON cp.CreatedBy = em.EmployeeID " +
                       "WHERE PatientID='" + ViewState["PatientID"].ToString() + "' ORDER BY ID DESC ";

        DataTable dt = StockReports.GetDataTable(query);

        if (dt.Rows.Count > 0)
        {
            grdNeu.DataSource = dt;
            grdNeu.DataBind();
            pnlGrid.Visible = true;
        }
        else
        {
            grdNeu.DataSource = null;
            grdNeu.DataBind();
            pnlGrid.Visible = false;
        }
    }

    private void BindDetails(int ID)
    {
        DataTable dtDetails = StockReports.GetDataTable("SELECT * FROM cpoe_Neurological_Analysis WHERE ID = " + ID + "");

        if (dtDetails.Rows.Count > 0)
        {
            lblID.Text = Util.GetString(ID);

            txtNote.Text = dtDetails.Rows[0]["Note"].ToString();

            if (dtDetails.Rows[0]["IsNeurologicalExam"] != null && dtDetails.Rows[0]["IsNeurologicalExam"].ToString() != "")
            {
                for (int i = 0; i < chkNeurologicalExam.Items.Count; i++)
                {
                    if (chkNeurologicalExam.Items[i].Text == dtDetails.Rows[0]["IsNeurologicalExam"].ToString())
                    {
                        chkNeurologicalExam.Items[i].Selected = true;
                    }
                }
            }

            txtMuscleR1.Text = dtDetails.Rows[0]["MuscleR1"].ToString();
            txtMuscleR2.Text = dtDetails.Rows[0]["MuscleR2"].ToString();
            txtMuscleR3.Text = dtDetails.Rows[0]["MuscleR3"].ToString();
            txtMuscleR4.Text = dtDetails.Rows[0]["MuscleR4"].ToString();
            txtMuscleR5.Text = dtDetails.Rows[0]["MuscleR5"].ToString();
            txtMuscleR6.Text = dtDetails.Rows[0]["MuscleR6"].ToString();
            txtMuscleR7.Text = dtDetails.Rows[0]["MuscleR7"].ToString();
            txtMuscleR8.Text = dtDetails.Rows[0]["MuscleR8"].ToString();
            txtMuscleR9.Text = dtDetails.Rows[0]["MuscleR9"].ToString();
            txtMuscleR10.Text = dtDetails.Rows[0]["MuscleR10"].ToString();
            txtMuscleL1.Text = dtDetails.Rows[0]["MuscleL1"].ToString();
            txtMuscleL2.Text = dtDetails.Rows[0]["MuscleL2"].ToString();
            txtMuscleL3.Text = dtDetails.Rows[0]["MuscleL3"].ToString();
            txtMuscleL4.Text = dtDetails.Rows[0]["MuscleL4"].ToString();
            txtMuscleL5.Text = dtDetails.Rows[0]["MuscleL5"].ToString();
            txtMuscleL6.Text = dtDetails.Rows[0]["MuscleL6"].ToString();
            txtMuscleL7.Text = dtDetails.Rows[0]["MuscleL7"].ToString();
            txtMuscleL8.Text = dtDetails.Rows[0]["MuscleL8"].ToString();
            txtMuscleL9.Text = dtDetails.Rows[0]["MuscleL9"].ToString();
            txtMuscleL10.Text = dtDetails.Rows[0]["MuscleL10"].ToString();
            txtDermatoneR1.Text = dtDetails.Rows[0]["DermatoneR1"].ToString();
            txtDermatoneR2.Text = dtDetails.Rows[0]["DermatoneR2"].ToString();
            txtDermatoneR3.Text = dtDetails.Rows[0]["DermatoneR3"].ToString();
            txtDermatoneR4.Text = dtDetails.Rows[0]["DermatoneR4"].ToString();
            txtDermatoneR5.Text = dtDetails.Rows[0]["DermatoneR5"].ToString();
            txtDermatoneR6.Text = dtDetails.Rows[0]["DermatoneR6"].ToString();
            txtDermatoneR7.Text = dtDetails.Rows[0]["DermatoneR7"].ToString();
            txtDermatoneR8.Text = dtDetails.Rows[0]["DermatoneR8"].ToString();
            txtDermatoneR9.Text = dtDetails.Rows[0]["DermatoneR9"].ToString();
            txtDermatoneR10.Text = dtDetails.Rows[0]["DermatoneR10"].ToString();
            txtDermatoneR11.Text = dtDetails.Rows[0]["DermatoneR11"].ToString();
            txtDermatoneR12.Text = dtDetails.Rows[0]["DermatoneR12"].ToString();
            txtDermatoneL1.Text = dtDetails.Rows[0]["DermatoneL1"].ToString();
            txtDermatoneL2.Text = dtDetails.Rows[0]["DermatoneL2"].ToString();
            txtDermatoneL3.Text = dtDetails.Rows[0]["DermatoneL3"].ToString();
            txtDermatoneL4.Text = dtDetails.Rows[0]["DermatoneL4"].ToString();
            txtDermatoneL5.Text = dtDetails.Rows[0]["DermatoneL5"].ToString();
            txtDermatoneL6.Text = dtDetails.Rows[0]["DermatoneL6"].ToString();
            txtDermatoneL7.Text = dtDetails.Rows[0]["DermatoneL7"].ToString();
            txtDermatoneL8.Text = dtDetails.Rows[0]["DermatoneL8"].ToString();
            txtDermatoneL9.Text = dtDetails.Rows[0]["DermatoneL9"].ToString();
            txtDermatoneL10.Text = dtDetails.Rows[0]["DermatoneL10"].ToString();
            txtDermatoneL11.Text = dtDetails.Rows[0]["DermatoneL11"].ToString();
            txtDermatoneL12.Text = dtDetails.Rows[0]["DermatoneL12"].ToString();

            if (dtDetails.Rows[0]["IsPersonalsensation"] != null && dtDetails.Rows[0]["IsPersonalsensation"].ToString() != "")
            {
                for (int i = 0; i < chkSacralRoot.Items.Count; i++)
                {
                    if (chkSacralRoot.Items[i].Text == dtDetails.Rows[0]["IsPersonalsensation"].ToString())
                    {
                        chkSacralRoot.Items[i].Selected = true;
                    }
                }
            }

            if (dtDetails.Rows[0]["IsRectal"] != null && dtDetails.Rows[0]["IsRectal"].ToString() != "")
            {
                for (int i = 0; i < chkSacralRootrectal.Items.Count; i++)
                {
                    if (chkSacralRootrectal.Items[i].Text == dtDetails.Rows[0]["IsRectal"].ToString())
                    {
                        chkSacralRootrectal.Items[i].Selected = true;
                    }
                }
            }

            chkReflexesR1.Text = dtDetails.Rows[0]["ReflexesR1"].ToString();
            chkReflexesR2.Text = dtDetails.Rows[0]["ReflexesR2"].ToString();
            chkReflexesR3.Text = dtDetails.Rows[0]["ReflexesR3"].ToString();
            chkReflexesR4.Text = dtDetails.Rows[0]["ReflexesR4"].ToString();
            chkReflexesL1.Text = dtDetails.Rows[0]["ReflexesL1"].ToString();
            chkReflexesL2.Text = dtDetails.Rows[0]["ReflexesL2"].ToString();
            chkReflexesL3.Text = dtDetails.Rows[0]["ReflexesL3"].ToString();
            chkReflexesL4.Text = dtDetails.Rows[0]["ReflexesL4"].ToString();

            if (dtDetails.Rows[0]["IsAnkleClonus"] != null && dtDetails.Rows[0]["IsAnkleClonus"].ToString() != "")
            {
                for (int i = 0; i < chkAncleclonus.Items.Count; i++)
                {
                    if (chkAncleclonus.Items[i].Text == dtDetails.Rows[0]["IsAnkleClonus"].ToString())
                    {
                        chkAncleclonus.Items[i].Selected = true;
                    }
                }
            }

            if (dtDetails.Rows[0]["IsAnkleClonusR1"] != null && dtDetails.Rows[0]["IsAnkleClonusR1"].ToString() != "")
            {
                for (int i = 0; i < chkAnkleClonusR1.Items.Count; i++)
                {
                    if (chkAnkleClonusR1.Items[i].Text == dtDetails.Rows[0]["IsAnkleClonusR1"].ToString())
                    {
                        chkAnkleClonusR1.Items[i].Selected = true;
                    }
                }
            }

            if (dtDetails.Rows[0]["IsAnkleClonusR2"] != null && dtDetails.Rows[0]["IsAnkleClonusR2"].ToString() != "")
            {
                for (int i = 0; i < chkAnkleClonusR2.Items.Count; i++)
                {
                    if (chkAnkleClonusR2.Items[i].Text == dtDetails.Rows[0]["IsAnkleClonusR2"].ToString())
                    {
                        chkAnkleClonusR2.Items[i].Selected = true;
                    }
                }
            }

            if (dtDetails.Rows[0]["IsAnkleClonusL1"] != null && dtDetails.Rows[0]["IsAnkleClonusL1"].ToString() != "")
            {
                for (int i = 0; i < chkAnkleClonusL1.Items.Count; i++)
                {
                    if (chkAnkleClonusL1.Items[i].Text == dtDetails.Rows[0]["IsAnkleClonusL1"].ToString())
                    {
                        chkAnkleClonusL1.Items[i].Selected = true;
                    }
                }
            }

            if (dtDetails.Rows[0]["IsAnkleClonusL2"] != null && dtDetails.Rows[0]["IsAnkleClonusL2"].ToString() != "")
            {
                for (int i = 0; i < chkAnkleClonusL2.Items.Count; i++)
                {
                    if (chkAnkleClonusL2.Items[i].Text == dtDetails.Rows[0]["IsAnkleClonusL2"].ToString())
                    {
                        chkAnkleClonusL2.Items[i].Selected = true;
                    }
                }
            }

            btnPrint.Visible = true;
        }

        if (ViewState["IsViewable"] != null && ViewState["IsViewable"].ToString() == "0")
        {
            btnSave.Visible = false;
            lblMsg.Text = "You Can Only View Data";
            MakeReadOnly();
        }
    }

    private void MakeReadOnly()
    {
        txtMuscleR1.ReadOnly = true;
        txtMuscleR2.ReadOnly = true;
        txtMuscleR3.ReadOnly = true;
        txtMuscleR4.ReadOnly = true;
        txtMuscleR5.ReadOnly = true;
        txtMuscleR6.ReadOnly = true;
        txtMuscleR7.ReadOnly = true;
        txtMuscleR8.ReadOnly = true;
        txtMuscleR9.ReadOnly = true;
        txtMuscleR10.ReadOnly = true;
        txtMuscleL1.ReadOnly = true;
        txtMuscleL2.ReadOnly = true;
        txtMuscleL3.ReadOnly = true;
        txtMuscleL4.ReadOnly = true;
        txtMuscleL5.ReadOnly = true;
        txtMuscleL6.ReadOnly = true;
        txtMuscleL7.ReadOnly = true;
        txtMuscleL8.ReadOnly = true;
        txtMuscleL9.ReadOnly = true;
        txtMuscleL10.ReadOnly = true;
        txtDermatoneR1.ReadOnly = true;
        txtDermatoneR2.ReadOnly = true;
        txtDermatoneR3.ReadOnly = true;
        txtDermatoneR4.ReadOnly = true;
        txtDermatoneR5.ReadOnly = true;
        txtDermatoneR6.ReadOnly = true;
        txtDermatoneR7.ReadOnly = true;
        txtDermatoneR8.ReadOnly = true;
        txtDermatoneR9.ReadOnly = true;
        txtDermatoneR10.ReadOnly = true;
        txtDermatoneR11.ReadOnly = true;
        txtDermatoneR12.ReadOnly = true;
        txtDermatoneL1.ReadOnly = true;
        txtDermatoneL2.ReadOnly = true;
        txtDermatoneL3.ReadOnly = true;
        txtDermatoneL4.ReadOnly = true;
        txtDermatoneL5.ReadOnly = true;
        txtDermatoneL6.ReadOnly = true;
        txtDermatoneL7.ReadOnly = true;
        txtDermatoneL8.ReadOnly = true;
        txtDermatoneL9.ReadOnly = true;
        txtDermatoneL10.ReadOnly = true;
        txtDermatoneL11.ReadOnly = true;
        txtDermatoneL12.ReadOnly = true;
        chkReflexesR1.ReadOnly = true;
        chkReflexesR2.ReadOnly = true;
        chkReflexesR3.ReadOnly = true;
        chkReflexesR4.ReadOnly = true;
        chkReflexesL1.ReadOnly = true;
        chkReflexesL2.ReadOnly = true;
        chkReflexesL3.ReadOnly = true;
        chkReflexesL4.ReadOnly = true;
    }
}