using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_MRD_PatientICDCodes : System.Web.UI.Page
    {
    private static List<string> listDiagnosis = new List<string>();
    protected void Page_Load(object sender, EventArgs e)
        {
        lblMsg.Text = "";
        if (!IsPostBack)
            {
            if (Request.QueryString["TID"] != null)
                {
                ViewState["TID"] =  Request.QueryString["TID"].ToString();
                }
            ViewState["Diagnosis"] = "";
            ViewState["ID"] = Session["ID"].ToString();
            ViewState["dtItem"] = GetItem();
            txtDig.Attributes.Add("onKeyPress", "doClick('" + btnSelect.ClientID + "',event)");

            txtCode.Attributes.Add("onKeyPress", "doClick('" + btnSelect.ClientID + "',event)");
            btnAdd.Visible = false;
            btnSave.Visible = false;
            }
        }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        string TID = ViewState["TID"].ToString();
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        try
        {
            foreach (GridViewRow gr in grvDig.Rows)
            {
                string sql = " insert into icd_10cm_patient(icd_id,TransactionID,UserID,icd_code,IsActive,CentreID) values(" + ((Label)gr.FindControl("lblCodeID")).Text.Trim() + ",'" + TID + "','" + ViewState["ID"].ToString() + "','" + ((Label)gr.FindControl("lblICDCode")).Text + "',1,"+Session["CentreID"]+")";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
            }

            tnx.Commit();

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Record Saved Successfully',function(){});", true);
            grvDig.DataSource = null;
            grvDig.DataBind();
            pnlHide.Visible = false;
            ViewState["dtItem"] = null;
            txtCode.Text = "";
            txtDig.Text = "";
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Error occurred, Please contact administrator',function(){});", true);
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

    protected void btnSelect_Click(object sender, EventArgs e)
        {
        try
            {
            grvCode.DataSource = null;
            grvCode.DataBind();

            string sql = " select ID,Diagnosis_Description Diagnosis,Diagnosis_Code Code,section from icd_10_new Where ID >0 and Isactive=1 ";

            if (txtDig.Text.Trim() != "")
                sql += " and Diagnosis_Description like '" + txtDig.Text.Trim() + "%'";

            if (txtCode.Text.Trim() != "")
                sql += " and Diagnosis_Code like '" + txtCode.Text.Trim() + "%'";

            sql += " order by section,Diagnosis_Description,Diagnosis_Code ";

            DataTable dt = StockReports.GetDataTable(sql);

            grvCode.DataSource = dt;
            grvCode.DataBind();
            btnAdd.Visible = true;
            }
        catch (Exception ex)
            {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            }
        }

    protected void btnAdd_Click(object sender, EventArgs e)
        {
        BindGridICD();
        }

    public void BindGridICDNew()
        {
        DataTable dtItem = new DataTable();
        dtItem = (DataTable)ViewState["dtItem"];

        DataRow dr = dtItem.NewRow();
        dr["ID"] = ViewState["IDICDCODE"].ToString();
        dr["ICD10_3_Code"] = txtSubSectionCode.Text.ToString();
        dr["ICD10_3_Code_Desc"] = txtSubSection.Text.ToString();
        dr["ICD10_Code"] = txtDiagnosisCode.Text.ToString();
        dr["WHO_Full_Desc"] = txtDiagnosisDesc.Text.ToString();

        dtItem.Rows.Add(dr);
        if (dtItem.Rows.Count > 0)
            {
            pnlHide.Visible = true;
            grvDig.DataSource = dtItem;
            grvDig.DataBind();
            btnSave.Visible = true;
            }
        txtCode.Text = "";
        txtDig.Text = "";

        grvCode.DataSource = null;
        grvCode.DataBind();
        }

    public void BindGridICDNewcancel()
        {
        DataTable dtItem = new DataTable();
        dtItem = (DataTable)ViewState["dtItem"];

        if (grdIcd.Rows.Count > 0)
            {
            foreach (GridViewRow grv in grdIcd.Rows)
                {
                DataRow dr = dtItem.NewRow();
                dr["ID"] = grv.Cells[0].Text;
                dr["ICD10_3_Code"] = grv.Cells[1].Text;
                dr["ICD10_3_Code_Desc"] = grv.Cells[2].Text;
                dr["ICD10_Code"] = grv.Cells[3].Text;
                dr["WHO_Full_Desc"] = grv.Cells[4].Text;
                dtItem.Rows.Add(dr);
                //
                }

            grvDig.DataSource = dtItem;
            grvDig.DataBind();
            }
        txtCode.Text = "";
        txtDig.Text = "";

        grvCode.DataSource = null;
        grvCode.DataBind();
        }

    protected void btnSave1_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();

        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (txtSectionId.Text.ToString() == "")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM130','" + lblMsg.ClientID + "');", true);
                mpe.Show();
                return;
            }
            if (txtSection.Text.ToString() == "")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM131','" + lblMsg.ClientID + "');", true);
                mpe.Show();
                return;
            }
            if (txtDiagnosisCode.Text.ToString() == "")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM132','" + lblMsg.ClientID + "');", true);
                mpe.Show();
                return;
            }
            if (txtDiagnosisDesc.Text.ToString() == "")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM133','" + lblMsg.ClientID + "');", true);
                mpe.Show();
                return;
            }
            if (ViewState["Diagnosis"].ToString() != "")
            {
                string str = "Update  icd_10_new set Isactive=0 where ICD10_Code='" + ViewState["Diagnosis"].ToString() + "' ";
                int result = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
            }

            string strInsert = "Insert Into icd_10_new(Group_Code,Group_Desc,ICD10_3_Code,ICD10_3_Code_Desc,ICD10_Code,WHO_Full_Desc) Values ('" + txtSectionId.Text.ToString() + "','" + txtSection.Text.ToString() + "','" + txtSubSectionCode.Text.ToString() + "','" + txtSubSection.Text.ToString() + "','" + txtDiagnosisCode.Text.ToString() + "','" + txtDiagnosisDesc.Text.Trim() + "'); SELECT LAST_INSERT_ID() ";
            MySqlCommand cmd = new MySqlCommand(strInsert, tnx.Connection, tnx);

            string ID = Util.GetString(cmd.ExecuteScalar().ToString());
            ViewState["IDICDCODE"] = ID;
            if (ID != "")
            {
                tnx.Commit();
                
                if (chkAddtoPatient.Checked == true)
                {
                    BindGridICDNew();
                }
                Clear();
            }
        }
        catch (Exception ex)
        {
            lblmsgpop.Text = ex.Message;
            tnx.Rollback();

            Clear();
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void btnNewIcd_Click(object sender, EventArgs e)
        {
        listDiagnosis.Clear();
        Clear();
        string str1 = "select UPPER(ICD10_Code)ICD10_Code from icd_10_new WHERE ID >0 and Isactive=1";
        DataTable dt1 = StockReports.GetDataTable(str1);
        if (dt1.Rows.Count > 0)
            {
            foreach (DataRow dr in dt1.Rows)
                {
                string item = Util.GetString(dr["ICD10_Code"]);
                listDiagnosis.Add(item.Replace("\n", "").Trim());
                }
            }
        btnSave1.Visible = false;
        mpe.Show();
        }

    protected void btnSearch_Click(object sender, EventArgs e)
        {
        ViewState["Diagnosis"] = "";

        if (txtDiagnosisCode.Text.ToString() != "")
            {
            string Diagnosis = Util.GetString(txtDiagnosisCode.Text.ToString()).ToUpper();

            if (listDiagnosis.Contains(Diagnosis))
                {
                lblmsgpop.Text = "Record Already Exist";
                string str = "SELECT ID,ICD10_3_Code ,ICD10_3_Code_Desc ,ICD10_Code ,WHO_Full_Desc  FROM icd_10_new WHERE ID >0 and Isactive=1 AND ICD10_Code='" + Diagnosis + "'  ";
                DataTable dt = StockReports.GetDataTable(str);

                grdIcd.Visible = true;
                grdIcd.DataSource = dt;
                grdIcd.DataBind();

                txtDiagnosisCode.Enabled = false;
                btnSearch.Visible = false;
                ViewState["Diagnosis"] = Diagnosis;
                btnSave1.Visible = true;
                mpe.Show();
                }
            else
                {
                MySqlConnection con = Util.GetMySqlCon();
                con.Open();

                MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
                try
                    {
                    // && txtDiagnosisCode.Text.ToString() == "" && txtSection.Text.ToString() == "" &&  txtDiagnosisCode.Text.ToString() == "")
                    if (txtSectionId.Text.ToString() == "")
                        {
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM130','" + lblMsg.ClientID + "');", true);
                        mpe.Show();
                        return;
                        }
                    if (txtSection.Text.ToString() == "")
                        {
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM131','" + lblMsg.ClientID + "');", true);
                        mpe.Show();
                        return;
                        }
                    if (txtDiagnosisCode.Text.ToString() == "")
                        {
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM132','" + lblMsg.ClientID + "');", true);
                        mpe.Show();
                        return;
                        }
                    if (txtDiagnosisDesc.Text.ToString() == "")
                        {
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM133','" + lblMsg.ClientID + "');", true);
                        mpe.Show();
                        return;
                        }

                    if (ViewState["Diagnosis"].ToString() != "")
                        {
                        // string str = "delete from icd_10cm_new where Diagnosis_Code='" + ViewState["Diagnosis"].ToString() + "' ";
                        string str = "Update  icd_10_new set Isactive=0 where ICD10_Code='" + ViewState["Diagnosis"].ToString() + "' ";
                        int result = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
                        }

                    string strInsert = "Insert Into icd_10_new(Group_Code,Group_Desc,ICD10_3_Code,ICD10_3_Code_Desc,ICD10_Code,WHO_Full_Desc) Values ('" + txtSectionId.Text.ToString() + "','" + txtSection.Text.ToString() + "','" + txtSubSectionCode.Text.Trim() + "','" + txtSubSection.Text.ToString() + "','" + txtDiagnosisCode.Text.ToString() + "','" + txtDiagnosisDesc.Text.ToString() + "'); SELECT LAST_INSERT_ID() ";

                    MySqlCommand cmd = new MySqlCommand(strInsert, tnx.Connection, tnx);
                    string ID = Util.GetString(cmd.ExecuteScalar().ToString());
                    ViewState["IDICDCODE"] = ID;
                    if (ID != "")
                        {
                        tnx.Commit();
                        tnx.Dispose();
                        con.Close();
                        con.Dispose();
                        if (chkAddtoPatient.Checked == true)
                            {
                            BindGridICDNew();
                            }
                        Clear();
                        }
                    }
                catch (Exception ex)
                    {
                    lblmsgpop.Text = ex.Message;
                    tnx.Rollback();
                    tnx.Dispose();
                    con.Close();
                    con.Dispose();
                    Clear();
                    }
                }
            }
        else
            {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM129','" + lblmsgpop.ClientID + "');", true);
            mpe.Show();
            }
        }

    protected void btnCancel_Click(object sender, EventArgs e)
        {
        if (chkAddtoPatient.Checked == true)
            {
            BindGridICDNewcancel();
            }
        Clear();
        mpe.Hide();
        }

    private void Clear()
        {
        txtDiagnosisCode.Enabled = true;
        btnSearch.Visible = true;
        btnSave1.Visible = false;
        lblmsgpop.Text = "";
        txtSection.Text = "";
        txtSectionId.Text = "";
        txtSubSection.Text = "";
        txtDiagnosisCode.Text = "";
        txtDiagnosisDesc.Text = "";
        grdIcd.DataSource = null;
        grdIcd.DataBind();
        txtSubSectionCode.Text = "";
        }

    public void BindGridICD()
        {
        int status = 0;
        DataTable dtItem = new DataTable();
        dtItem = (DataTable)ViewState["dtItem"];

        foreach (GridViewRow grv in grvCode.Rows)
            {
            if (((CheckBox)grv.FindControl("chkSelect")).Checked)
                {
                DataRow dr = dtItem.NewRow();
                dr["ID"] = ((Label)grv.FindControl("lblID")).Text;
                dr["ICD10_3_Code"] = grv.Cells[1].Text;
                dr["ICD10_3_Code_Desc"] = grv.Cells[2].Text;
                dr["ICD10_Code"] = grv.Cells[3].Text;
                dr["WHO_Full_Desc"] = grv.Cells[4].Text;
                dtItem.Rows.Add(dr);
                status = 1;
                }
            }

        if (status == 0)
            {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM018','" + lblMsg.ClientID + "');", true);
            return;
            }

        grvDig.DataSource = dtItem;
        grvDig.DataBind();
        btnSave.Visible = true;

        txtCode.Text = "";
        txtDig.Text = "";

        grvCode.DataSource = null;
        grvCode.DataBind();
        }

    private DataTable GetItem()
        {
        if (ViewState["dtItem"] != null)
            {
            return (DataTable)ViewState["dtItem"];
            }
        else
            {
            DataTable dtItem = new DataTable();
            dtItem.Columns.Add("ID");
            dtItem.Columns.Add("ICD10_3_Code");
            dtItem.Columns.Add("ICD10_3_Code_Desc");
            dtItem.Columns.Add("ICD10_Code");
            dtItem.Columns.Add("WHO_Full_Desc");
            return dtItem;
            }
        }

    protected void grdDig_RowCommand(object sender, GridViewCommandEventArgs e)
        {
        if (e.CommandName == "imbRemove")
            {
            int args = Util.GetInt(e.CommandArgument);
            DataTable dtItem = (DataTable)ViewState["dtItem"];
            dtItem.Rows[args].Delete();
            dtItem.AcceptChanges();
            grvDig.DataSource = dtItem;
            grvDig.DataBind();
            ViewState["dtItem"] = dtItem;
            if (dtItem.Rows.Count == 0)
                {
                btnSave.Visible = false;
                btnAdd.Visible = false;
                pnlHide.Visible = false;
                }
            }
        }

    protected void btnAddICD_Click(object sender, EventArgs e)
        {
        MySqlConnection con = Util.GetMySqlCon();
        try
            {
            int ICDCode = Util.GetInt(StockReports.ExecuteScalar("Select Count(*) from icd_10cm_patient icp inner join icd_10_new icn on icp.ICD_Code=icn.ICD10_Code where icn.Who_full_desc='" + txtDig.Text.Trim() + "' and TransactionID='" + ViewState["TID"].ToString() + "' and icp.isactive=1"));
            if (ICDCode == 0)
                {
                string sql = " select ID,ICD10_3_Code,ICD10_3_Code_Desc,ICD10_Code, WHO_Full_Desc from icd_10_new Where WHO_Full_Desc=@WHO_Full_Desc  and Isactive=1 ";
                sql += " order by ICD10_Code ";
                MySqlParameter param = new MySqlParameter("@WHO_Full_Desc", txtDig.Text.Trim());
                MySqlCommand cmd = new MySqlCommand(sql, con);
                cmd.Parameters.Add(param);
                MySqlDataAdapter da = new MySqlDataAdapter(cmd);

                DataTable dt = new DataTable();
                da.Fill(dt);
                if (dt.Rows.Count > 0)
                    {
                    DataTable dtItem = new DataTable();
                    if (ViewState["dtItem"] != null)
                        {
                        dtItem = (DataTable)ViewState["dtItem"];
                        if (dtItem != null && dtItem.Rows.Count > 0)
                            {
                            string str = dt.Rows[0]["ICD10_Code"].ToString();
                            foreach (DataRow drItem in dtItem.Rows)
                                {
                                if (str == drItem["ICD10_Code"].ToString())
                                    {
                                    lblMsg.Text = "ICD Code Already Added";
                                    return;
                                    }
                                }
                            }
                        dtItem.AcceptChanges();
                        }
                    else
                        dtItem = GetItem();

                    DataRow dr = dtItem.NewRow();
                    dr["ID"] = dt.Rows[0]["ID"].ToString();
                    dr["ICD10_3_Code"] = dt.Rows[0]["ICD10_3_Code"].ToString();
                    dr["ICD10_3_Code_Desc"] = dt.Rows[0]["ICD10_3_Code_Desc"].ToString();
                    dr["ICD10_Code"] = dt.Rows[0]["ICD10_Code"].ToString();
                    dr["WHO_Full_Desc"] = dt.Rows[0]["WHO_Full_Desc"].ToString();
                    dtItem.Rows.Add(dr);

                    ViewState.Add("dtItems", dtItem);
                    if (dtItem.Rows.Count > 0)
                        {
                        grvDig.DataSource = dtItem;
                        grvDig.DataBind();
                        btnSave.Visible = true;
                        pnlHide.Visible = true;
                        txtDig.Text = "";
                        }
                    else
                        {
                        grvDig.DataSource = null;
                        grvDig.DataBind();
                        btnSave.Visible = false;
                        pnlHide.Visible = false;
                        }
                    }
                else
                    {
                    lblMsg.Text = "ICD Desc. not matched";
                    return;
                    }
                }
            else
                {
                lblMsg.Text = "Already Added ICD Code";
                return;
                }
            }
        catch (Exception ex)
            {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            }
        finally
            {
            con.Dispose();
            }
        }

    protected void btnAddICDCode_Click(object sender, EventArgs e)
        {
        MySqlConnection con = Util.GetMySqlCon();
        try
            {
            int ICDCode = Util.GetInt(StockReports.ExecuteScalar("Select Count(*) from icd_10cm_patient where ICD_Code='" + txtCode.Text.Trim() + "' and TransactionID='" + ViewState["TID"].ToString() + "' and IsActive=1"));
            if (ICDCode == 0)
                {
                string sql = " select ID,ICD10_3_Code,ICD10_3_Code_Desc,ICD10_Code, WHO_Full_Desc from icd_10_new Where ICD10_Code=@ICD10_Code  and Isactive=1 ";
                sql += " order by ICD10_Code ";
                MySqlParameter param = new MySqlParameter("@ICD10_Code", txtCode.Text.Trim());
                MySqlCommand cmd = new MySqlCommand(sql, con);
                cmd.Parameters.Add(param);
                MySqlDataAdapter da = new MySqlDataAdapter(cmd);

                DataTable dt = new DataTable();
                da.Fill(dt);
                DataTable dtItem = new DataTable();
                if (ViewState["dtItem"] != null)
                    {
                    dtItem = (DataTable)ViewState["dtItem"];
                    if (dtItem != null && dtItem.Rows.Count > 0)
                        {
                        string str = dt.Rows[0]["ICD10_Code"].ToString();
                        foreach (DataRow drItem in dtItem.Rows)
                            {
                            if (str == drItem["ICD10_Code"].ToString())
                                {
                                lblMsg.Text = "ICD Code Already Added";
                                return;
                                }
                            }
                        }
                    dtItem.AcceptChanges();
                    }
                else
                    dtItem = GetItem();

                DataRow dr = dtItem.NewRow();
                dr["ID"] = dt.Rows[0]["ID"].ToString();
                dr["ICD10_3_Code"] = dt.Rows[0]["ICD10_3_Code"].ToString();
                dr["ICD10_3_Code_Desc"] = dt.Rows[0]["ICD10_3_Code_Desc"].ToString();
                dr["ICD10_Code"] = dt.Rows[0]["ICD10_Code"].ToString();
                dr["WHO_Full_Desc"] = dt.Rows[0]["WHO_Full_Desc"].ToString();
                dtItem.Rows.Add(dr);

                ViewState.Add("dtItems", dtItem);
                if (dtItem.Rows.Count > 0)
                    {
                    grvDig.DataSource = dtItem;
                    grvDig.DataBind();
                    btnSave.Visible = true;
                    pnlHide.Visible = true;
                    txtDig.Text = "";
                    }
                else
                    {
                    grvDig.DataSource = null;
                    grvDig.DataBind();
                    btnSave.Visible = false;
                    pnlHide.Visible = false;
                    }
                }
            else
                {
                lblMsg.Text = "Already Added ICD Code";
                return;
                }
            }
        catch (Exception ex)
            {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            }
        finally
            {
            con.Dispose();
            }
        }

}