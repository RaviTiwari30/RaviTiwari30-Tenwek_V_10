using System;
using System.Data;
using MySql.Data.MySqlClient;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;
public partial class Design_IPD_PatientOrderSetSearch : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ucFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            BindDoctor();
            All_LoadData.BindOrderSet(ddlOrderSet);
            txtPatientID.Focus();
            BindOrderType();
        }
        ucFromDate.Attributes.Add("readOnly", "true");
        ucToDate.Attributes.Add("readOnly", "true");
    }
    protected void BindOrderType()
    {
        if (Session["RoleID"].ToString() == "164")
            ddlOrderType.SelectedIndex = ddlOrderType.Items.IndexOf(ddlOrderType.Items.FindByText("Physio"));
        else if (Session["RoleID"].ToString() == "165")
            ddlOrderType.SelectedIndex = ddlOrderType.Items.IndexOf(ddlOrderType.Items.FindByText("Nutrition"));
        else if (Session["RoleID"].ToString() == "167" || Session["RoleID"].ToString() == "168" || Session["RoleID"].ToString() == "166" || Session["RoleID"].ToString() == "108" || Session["RoleID"].ToString() == "111")
            ddlOrderType.SelectedIndex = ddlOrderType.Items.IndexOf(ddlOrderType.Items.FindByText("Nursing"));
        else
            ddlOrderType.SelectedIndex = ddlOrderType.Items.IndexOf(ddlOrderType.Items.FindByText("All"));
    }
    public void BindDoctor()
    {
        try
        {

            if (Convert.ToString(Session["LoginType"]).ToUpper() == "DOCTOR")
            {

                DataTable dt = All_LoadData.bindDoctor();
                cmbDoctor.DataSource = dt;
                cmbDoctor.DataTextField = "Name";
                cmbDoctor.DataValueField = "DoctorID";
                cmbDoctor.DataBind();
                cmbDoctor.Items.Insert(0, new ListItem("Select"));
                string str = "select DoctorID from doctor_employee where Employee_id='" + Convert.ToString(Session["ID"]) + "'";
                DataTable dtnew = StockReports.GetDataTable(str);
                if (dtnew != null && dtnew.Rows.Count > 0)
                {
                    cmbDoctor.SelectedIndex = cmbDoctor.Items.IndexOf(cmbDoctor.Items.FindByValue(Util.GetString(dtnew.Rows[0][0])));
                    cmbDoctor.Enabled = false;
                }

            }
            else
            {
                DataTable dt = All_LoadData.bindDoctor();
                cmbDoctor.DataSource = dt;
                cmbDoctor.DataTextField = "Name";
                cmbDoctor.DataValueField = "DoctorID";
                cmbDoctor.DataBind();
                cmbDoctor.Items.Insert(0, new ListItem("Select"));
            }
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            lblMsg.Text = ex.Message;
        }
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        if (ddlOrderType.SelectedItem.Value.ToUpper() == "ALL")
        {
            sb.Append(" SELECT pm.PatientID ,CONCAT(pm.title,' ',pm.Pname)PatientName,concat(pm.Age,' ','/',' ',pm.Gender)AgeSex,nos.Groups OrderSet,nos.Groupid,dm.DoctorID,dm.Name DoctorName,pmh.TransactionID,nos.RelationalID,DATE_FORMAT(nos.Createddate,'%d-%b-%y %h:%i %p')EntryDate,if(nos.IsReadNotification<>'0','Yes','No')IsReadNotification,'Nursing' Department,(Select Concat(title,' ',Name) from Employee_master where Employee_ID=nos.readBy)ReadBy FROM patient_medical_history  pmh");
            sb.Append("    INNER JOIN nursing_orderset_details nos ON nos.TransactionID=pmh.TransactionID");
            sb.Append("  INNER JOIN patient_master pm ON pm.PatientID=pmh.PatientID  INNER JOIN doctor_master dm ON dm.DoctorID=pmh.DoctorID WHERE pmh.Type='IPD' ");
            if (txtPatientID.Text != "")
            {
                sb.Append(" AND pm.PatientID='" + txtPatientID.Text.Trim() + "'");
            }

            if (txtName.Text != "")
            {
                sb.Append(" AND pm.pname like '%" + txtPatientID.Text.Trim() + "%'");
            }

            if (ddlOrderSet.SelectedIndex != 0)
            {
                sb.Append(" AND nos.GroupID ='" + ddlOrderSet.SelectedItem.Value + "'");
            }

            if (txtTransactionNo.Text.Trim() != "")
            {
                sb.Append(" AND nos.TransactionID ='ISHHI" + txtTransactionNo.Text.Trim() + "'");
            }
            if (cmbDoctor.SelectedIndex != 0)
            {
                sb.Append(" AND dm.DoctorID ='" + cmbDoctor.SelectedItem.Value + "'");
            }
            if (ddlOrderSet.SelectedIndex != 0)
            {
                sb.Append(" AND nos.GroupID ='" + ddlOrderSet.SelectedItem.Value + "'");
            }

            if (ucFromDate.Text.Trim() != "" && ucToDate.Text.Trim() != "")
            {
                sb.Append(" and date(nos.createdDate) >= '" + Util.GetDateTime(ucFromDate.Text.Trim()).ToString("yyyy-MM-dd") + "' and Date(nos.createdDate) <= '" + Util.GetDateTime(ucToDate.Text.Trim()).ToString("yyyy-MM-dd") + "'");
            }
            sb.Append(" GROUP BY nos.RelationalID");
            //Rehab Order Stes
            sb.Append(" union all");
            sb.Append(" SELECT pm.PatientID ,CONCAT(pm.title,' ',pm.Pname)PatientName,concat(pm.Age,' ','/',' ',pm.Gender)AgeSex,concat(reh.ordersettype,' (',side,')')Groups,'0' Groupid,em.Employee_ID,em.Name DoctorName,pmh.TransactionID,'0' RelationalID,DATE_FORMAT(reh.Entrydate,'%d-%b-%y %h:%i %p')EntryDate,if(reh.IsReadNotification<>'0','Yes','No')IsReadNotification,'Physio' Department,(Select Concat(title,' ',Name) from Employee_master where Employee_ID=reh.readBy)ReadBy FROM patient_medical_history  pmh");
            sb.Append(" INNER JOIN cpoe_rehaborder_set_detail reh ON reh.Transactionid=pmh.TransactionID");
            sb.Append(" INNER JOIN patient_master pm ON pm.PatientID=pmh.PatientID  INNER JOIN employee_master em ON em.Employee_ID=reh.EntryBy WHERE pmh.Type='IPD' ");
            if (txtPatientID.Text != "")
            {
                sb.Append(" AND pm.PatientID='" + txtPatientID.Text.Trim() + "'");
            }

            if (txtName.Text != "")
            {
                sb.Append(" AND pm.pname like '%" + txtPatientID.Text.Trim() + "%'");
            }
            if (txtTransactionNo.Text.Trim() != "")
            {
                sb.Append(" AND nos.TransactionID ='ISHHI" + txtTransactionNo.Text.Trim() + "'");
            }
            if (ucFromDate.Text.Trim() != "" && ucToDate.Text.Trim() != "")
            {
                sb.Append(" and date(reh.entryDate) >= '" + Util.GetDateTime(ucFromDate.Text.Trim()).ToString("yyyy-MM-dd") + "' and Date(reh.entryDate) <= '" + Util.GetDateTime(ucToDate.Text.Trim()).ToString("yyyy-MM-dd") + "'");
            }
            sb.Append(" GROUP BY ordersettype,side,reh.entrydate");

            //Diet Order Stes
            sb.Append(" union all");
            sb.Append(" SELECT pm.PatientID ,CONCAT(pm.title,' ',pm.Pname)PatientName,concat(pm.Age,' ','/',' ',pm.Gender)AgeSex,GroupName as Groups,'-1' Groupid,em.Employee_ID,em.Name DoctorName,pmh.TransactionID,RelationID as RelationalID,DATE_FORMAT(diet.Entrydate,'%d-%b-%y %h:%i %p')EntryDate,if(diet.IsReadNotification<>'0','Yes','No')IsReadNotification,'Nutrition' Department,(Select Concat(title,' ',Name) from Employee_master where Employee_ID=diet.readBy)ReadBy FROM patient_medical_history  pmh");
            sb.Append(" INNER JOIN Nursing_Orderset_diet diet ON diet.Transactionid=pmh.TransactionID");
            sb.Append(" INNER JOIN patient_master pm ON pm.PatientID=pmh.PatientID  INNER JOIN employee_master em ON em.Employee_ID=diet.EnterBy WHERE pmh.Type='IPD' ");
            if (txtPatientID.Text != "")
            {
                sb.Append(" AND pm.PatientID='" + txtPatientID.Text.Trim() + "'");
            }

            if (txtName.Text != "")
            {
                sb.Append(" AND pm.pname like '%" + txtPatientID.Text.Trim() + "%'");
            }
            if (txtTransactionNo.Text.Trim() != "")
            {
                sb.Append(" AND nos.TransactionID ='ISHHI" + txtTransactionNo.Text.Trim() + "'");
            }
            if (ucFromDate.Text.Trim() != "" && ucToDate.Text.Trim() != "")
            {
                sb.Append(" and date(diet.EntryDate) >= '" + Util.GetDateTime(ucFromDate.Text.Trim()).ToString("yyyy-MM-dd") + "' and Date(diet.EntryDate) <= '" + Util.GetDateTime(ucToDate.Text.Trim()).ToString("yyyy-MM-dd") + "'");
            }
            sb.Append(" GROUP BY RelationalID,diet.EntryDate");
        }
        else if (ddlOrderType.SelectedItem.Value.ToUpper() == "NURSING")
        {
            sb.Append(" SELECT pm.PatientID ,CONCAT(pm.title,' ',pm.Pname)PatientName,concat(pm.Age,' ','/',' ',pm.Gender)AgeSex,nos.Groups OrderSet,nos.Groupid,dm.DoctorID,dm.Name DoctorName,pmh.TransactionID,nos.RelationalID,DATE_FORMAT(nos.Createddate,'%d-%b-%y %h:%i %p')EntryDate,if(nos.IsReadNotification<>'0','Yes','No')IsReadNotification,'Nursing' Department,(Select Concat(title,' ',Name) from Employee_master where Employee_ID=nos.readBy)ReadBy FROM patient_medical_history  pmh");
            sb.Append("    INNER JOIN nursing_orderset_details nos ON nos.TransactionID=pmh.TransactionID");
            sb.Append("  INNER JOIN patient_master pm ON pm.PatientID=pmh.PatientID  INNER JOIN doctor_master dm ON dm.DoctorID=pmh.DoctorID WHERE pmh.Type='IPD' ");
            if (txtPatientID.Text != "")
            {
                sb.Append(" AND pm.PatientID='" + txtPatientID.Text.Trim() + "'");
            }

            if (txtName.Text != "")
            {
                sb.Append(" AND pm.pname like '%" + txtPatientID.Text.Trim() + "%'");
            }

            if (ddlOrderSet.SelectedIndex != 0)
            {
                sb.Append(" AND nos.GroupID ='" + ddlOrderSet.SelectedItem.Value + "'");
            }

            if (txtTransactionNo.Text.Trim() != "")
            {
                sb.Append(" AND nos.TransactionID ='ISHHI" + txtTransactionNo.Text.Trim() + "'");
            }
            if (cmbDoctor.SelectedIndex != 0)
            {
                sb.Append(" AND dm.DoctorID ='" + cmbDoctor.SelectedItem.Value + "'");
            }
            if (ddlOrderSet.SelectedIndex != 0)
            {
                sb.Append(" AND nos.GroupID ='" + ddlOrderSet.SelectedItem.Value + "'");
            }

            if (ucFromDate.Text.Trim() != "" && ucToDate.Text.Trim() != "")
            {
                sb.Append(" and date(nos.createdDate) >= '" + Util.GetDateTime(ucFromDate.Text.Trim()).ToString("yyyy-MM-dd") + "' and Date(nos.createdDate) <= '" + Util.GetDateTime(ucToDate.Text.Trim()).ToString("yyyy-MM-dd") + "'");
            }
            sb.Append(" GROUP BY nos.RelationalID");
        }
        else if (ddlOrderType.SelectedItem.Value.ToUpper() == "PHYSIO")
        {
            sb.Append(" SELECT pm.PatientID ,CONCAT(pm.title,' ',pm.Pname)PatientName,concat(pm.Age,' ','/',' ',pm.Gender)AgeSex,concat(reh.ordersettype,' (',side,')')OrderSet,'0' Groupid,em.Employee_ID,em.Name DoctorName,pmh.TransactionID,'0' RelationalID,DATE_FORMAT(reh.Entrydate,'%d-%b-%y %h:%i %p')EntryDate,if(reh.IsReadNotification<>'0','Yes','No')IsReadNotification,'Physio' Department,(Select Concat(title,' ',Name) from Employee_master where Employee_ID=reh.readBy)ReadBy FROM patient_medical_history  pmh");
            sb.Append(" INNER JOIN cpoe_rehaborder_set_detail reh ON reh.Transactionid=pmh.TransactionID");
            sb.Append(" INNER JOIN patient_master pm ON pm.PatientID=pmh.PatientID  INNER JOIN employee_master em ON em.Employee_ID=reh.EntryBy WHERE pmh.Type='IPD' ");
            if (txtPatientID.Text != "")
            {
                sb.Append(" AND pm.PatientID='" + txtPatientID.Text.Trim() + "'");
            }

            if (txtName.Text != "")
            {
                sb.Append(" AND pm.pname like '%" + txtPatientID.Text.Trim() + "%'");
            }
            if (txtTransactionNo.Text.Trim() != "")
            {
                sb.Append(" AND nos.TransactionID ='ISHHI" + txtTransactionNo.Text.Trim() + "'");
            }
            if (ucFromDate.Text.Trim() != "" && ucToDate.Text.Trim() != "")
            {
                sb.Append(" and date(reh.entryDate) >= '" + Util.GetDateTime(ucFromDate.Text.Trim()).ToString("yyyy-MM-dd") + "' and Date(reh.entryDate) <= '" + Util.GetDateTime(ucToDate.Text.Trim()).ToString("yyyy-MM-dd") + "'");
            }
            sb.Append(" GROUP BY ordersettype,side,reh.entrydate");
        }
        else if (ddlOrderType.SelectedItem.Value.ToUpper()=="NUTRITION")
        {
            //Diet Order Stes
            sb.Append(" SELECT pm.PatientID ,CONCAT(pm.title,' ',pm.Pname)PatientName,concat(pm.Age,' ','/',' ',pm.Gender)AgeSex,GroupName as OrderSet,'-1' Groupid,em.Employee_ID,em.Name DoctorName,pmh.TransactionID,RelationID as RelationalID,DATE_FORMAT(diet.Entrydate,'%d-%b-%y %h:%i %p')EntryDate,if(diet.IsReadNotification<>'0','Yes','No')IsReadNotification,'Nutrition' Department,(Select Concat(title,' ',Name) from Employee_master where Employee_ID=diet.readBy)ReadBy FROM patient_medical_history  pmh");
            sb.Append(" INNER JOIN Nursing_Orderset_diet diet ON diet.Transactionid=pmh.TransactionID");
            sb.Append(" INNER JOIN patient_master pm ON pm.PatientID=pmh.PatientID  INNER JOIN employee_master em ON em.Employee_ID=diet.EnterBy WHERE pmh.Type='IPD' ");
            if (txtPatientID.Text != "")
            {
                sb.Append(" AND pm.PatientID='" + txtPatientID.Text.Trim() + "'");
            }

            if (txtName.Text != "")
            {
                sb.Append(" AND pm.pname like '%" + txtPatientID.Text.Trim() + "%'");
            }
            if (txtTransactionNo.Text.Trim() != "")
            {
                sb.Append(" AND nos.TransactionID ='ISHHI" + txtTransactionNo.Text.Trim() + "'");
            }
            if (ucFromDate.Text.Trim() != "" && ucToDate.Text.Trim() != "")
            {
                sb.Append(" and date(diet.EntryDate) >= '" + Util.GetDateTime(ucFromDate.Text.Trim()).ToString("yyyy-MM-dd") + "' and Date(diet.EntryDate) <= '" + Util.GetDateTime(ucToDate.Text.Trim()).ToString("yyyy-MM-dd") + "'");
            }
            sb.Append(" GROUP BY RelationalID,diet.EntryDate");
        }
        DataTable Items = StockReports.GetDataTable(sb.ToString());

        if (Items.Rows.Count > 0)
        {
            lblMsg.Text = "";
            grdPatient.DataSource = Items;
            grdPatient.DataBind();
        }
        else
        {
            grdPatient.DataSource = null;
            grdPatient.DataBind();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
        }
    }

    protected void grdPatient_RowCommand(object sender, GridViewCommandEventArgs e)
    {

        if (e.CommandName == "view")
        {
            string TID = e.CommandArgument.ToString().Split('#')[0];
            string GroupID = e.CommandArgument.ToString().Split('#')[1];
            string RelationalID = e.CommandArgument.ToString().Split('#')[2];

            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            if (GroupID == "0")
            {
                try
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update cpoe_rehaborder_set_detail set IsReadNotification=1,ReadBy='" + Session["ID"].ToString() + "' where TransactionID='" + TID + "'");

                    tnx.Commit();
                    con.Close();
                    con.Dispose();
                }
                catch (Exception ex)
                {
                    tnx.Rollback();
                    tnx.Dispose();
                    con.Close();
                    con.Dispose();
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                }
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/CPOE/OrderSetPhysio_print.aspx?TID=" + TID + "');", true);
            }
            else if (GroupID == "-1")
            {
                try
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update nursing_orderset_diet set IsReadNotification=1,ReadBy='" + Session["ID"].ToString() + "' where TransactionID='" + TID + "'");

                    tnx.Commit();
                    con.Close();
                    con.Dispose();
                }
                catch (Exception ex)
                {
                    tnx.Rollback();
                    tnx.Dispose();
                    con.Close();
                    con.Dispose();
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                }
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/IPD/OrderSet/Nursing_OrderSet_Diet.aspx?TID=" + TID + "&IsRead=1&GroupID=0&RelationalID=" + RelationalID + "');", true);
            }
            else
            {
                try
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update nursing_orderset_details set IsReadNotification=1,ReadBy='" + Session["ID"].ToString() + "' where TransactionID='" + TID + "' and GroupID='" + GroupID + "' and RelationalID='" + RelationalID + "' ");

                    tnx.Commit();
                    con.Close();
                    con.Dispose();
                }
                catch (Exception ex)
                {
                    tnx.Rollback();
                    tnx.Dispose();
                    con.Close();
                    con.Dispose();
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                }

                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/IPD/NursingOrderSetPrintOut.aspx?TID=" + TID + "&GroupID=" + GroupID + "&RelationalID=" + RelationalID + "');", true);
            }
        }

    }
}