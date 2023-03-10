using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_IPD_IPD_FinalDiagnosis : System.Web.UI.Page
    {
    private static List<string> listDiagnosis = new List<string>();

    protected void Page_Load(object sender, EventArgs e)
        {
        if (!IsPostBack)
            {
            ViewState["ID"] = Session["ID"].ToString();

            string TID = string.Empty;

            if (Request.QueryString["TransactionID"] == null){
                TID = Request.QueryString["TID"].ToString();
				ViewState["PatientID"] = Request.QueryString["PID"].ToString();
				}
            else{
                TID = Request.QueryString["TransactionID"].ToString();
				                ViewState["PatientID"] = Request.QueryString["PatientID"].ToString();
}

            ViewState["TID"] = TID;




          
            //   Session["Sex"] = Request.QueryString["Sex"].ToString();
            ViewState["dtItem"] = GetItem();
            txtDig.Attributes.Add("onKeyPress", "doClick('" + btnSelect.ClientID + "',event)");
            ViewState["Diagnosis"] = "";
            txtCode.Attributes.Add("onKeyPress", "doClick('" + btnSelect.ClientID + "',event)");
            btnAdd.Visible = false;
            btnSave.Visible = false;
            BindPatient(ViewState["TID"].ToString());

            AllQuery AQ = new AllQuery();
            DataTable dtDischarge = AQ.GetPatientDischargeStatus(TID);
            if (Session["RoleID"].ToString() != "51")
            {
                if (dtDischarge != null && dtDischarge.Rows.Count > 0)
                {
                    if (dtDischarge.Rows[0]["Status"].ToString().Trim().ToUpper() == "OUT")
                    {
                        string Msg = "Patient is Already Discharged on " + Util.GetDateTime(dtDischarge.Rows[0]["DischargeDate"].ToString().Trim()).ToString("dd-MMM-yyyy") + " . No form can be fill...";
                        Response.Redirect("../IPD/PatientBillMsg.aspx?msg=" + Msg);
                    }
                }
            }
            DateTime AdmitDate = Util.GetDateTime(AQ.getAdmitDate(TID));
            }
        }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";

        string TID = ViewState["TID"].ToString();
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        try
            {
            foreach (GridViewRow gr in grvDig.Rows)
            {
                string addtopatientlist = "0";
                bool isyes = ((CheckBox)gr.FindControl("chkAddToProbList")).Checked;
                if (isyes == true)
                {
                    addtopatientlist = "1";
                }

                string sql = " insert into cpoe_10cm_patient(icd_id,TransactionID,PatientID,UserID,IsActive,ICD_Code,Remarks,AddToPatientList) values(" + ((Label)gr.FindControl("lblCodeID")).Text.Trim() + ",'" + TID + "','" + ViewState["PatientID"].ToString() + "','" + ViewState["ID"].ToString() + "',1,'" + ((Label)gr.FindControl("lblICDCode")).Text + "','" + txtComments.Text.Trim() + "','" + addtopatientlist + "')";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
            }

            tnx.Commit();

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
            grvDig.DataSource = null;
            grvDig.DataBind();
            pnlHide.Visible = false;
            ViewState["dtItem"] = null;
            BindPatient(ViewState["TID"].ToString());
            }
        catch (Exception ex)
            {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
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

        grvDig.DataSource = dtItem;
        grvDig.DataBind();

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
                lblmsgpop.Text = "Record Already Exist If You Want To Delete It And Save New Please Enter Save Else Enter Cancel";
                string str = "SELECT ID,ICD10_3_Code 'Sub Section',ICD10_3_Code,ICD10_3_Code_Desc 'Sub Section Desc.',ICD10_3_Code_Desc,ICD10_Code 'ICD Code',ICD10_Code,WHO_Full_Desc 'ICD Desc.',WHO_Full_Desc FROM icd_10_new WHERE ID >0 and Isactive=1 AND ICD10_Code='" + Diagnosis + "'  ";
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

                    Clear();
                }
                finally
                {
                    tnx.Dispose();
                    con.Close();
                    con.Dispose();
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
            dtItem.Columns.Add("Remarks");
            return dtItem;
        }
    }
    protected void grdDig_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "imbRemove")
        {
            int args = Util.GetInt(e.CommandArgument);
            DataTable dtItem = (DataTable)ViewState["dtItems"];
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
    protected void grvICDCode_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "imbRemove")
        {
            lblMsg.Text = "";
            string IPD = Util.GetString(e.CommandArgument).Split('#')[0];
            string args = Util.GetString(e.CommandArgument).Split('#')[2];
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();

            con.Open();
            MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
            int RowsUpdated = 0;

            try
            {
                string sql = "Update cpoe_10cm_patient set  IsActive=0 where id=" + args + "  and TransactionID='" + IPD.ToString() + "' ";
                RowsUpdated = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sql);
                Tranx.Commit();
                BindPatient(ViewState["TID"].ToString());
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM03','" + lblMsg.ClientID + "');", true);
            }
            catch (Exception ex)
            {
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
    protected void btnAddICD_Click(object sender, EventArgs e)
    {

        MySqlConnection con = Util.GetMySqlCon();
        try
        {
            int ICDCode = Util.GetInt(StockReports.ExecuteScalar("Select Count(*) from Cpoe_10cm_patient icp inner join icd_10_new icn on icp.ICD_Code=icn.ICD10_Code where icn.Who_full_desc='" + txtDig.Text.Trim() + "' and TransactionID='" + ViewState["TID"].ToString() + "' and icp.isactive=1"));
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
                dr["Remarks"] = txtComments.Text.Trim();
                
                dtItem.Rows.Add(dr);

                ViewState.Add("dtItems", dtItem);
                if (dtItem.Rows.Count > 0)
                {
                    grvDig.DataSource = dtItem;
                    grvDig.DataBind();
                    btnSave.Visible = true;
                    pnlHide.Visible = true;
                    txtDig.Text = "";
                    txtCode.Text = "";
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
            con.Close();
        }
    }
    protected void btnAddICDCode_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        try
        {
            int ICDCode = Util.GetInt(StockReports.ExecuteScalar("Select Count(*) from Cpoe_10cm_patient where ICD_Code='" + txtCode.Text.Trim() + "' and TransactionID='" + ViewState["TID"].ToString() + "' and IsActive=1"));
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
                dr["Remarks"] = txtComments.Text.Trim();
                dtItem.Rows.Add(dr);

                ViewState.Add("dtItems", dtItem);
                if (dtItem.Rows.Count > 0)
                {
                    grvDig.DataSource = dtItem;
                    grvDig.DataBind();
                    btnSave.Visible = true;
                    pnlHide.Visible = true;
                    txtDig.Text = "";
                    txtCode.Text = "";
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
            con.Close();
        }
    }
    private void BindPatient(string TID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT REPLACE(icdp.TransactionID,'ISHHI','')'IPD No.',TransactionID,Group_Code ,Group_Desc , ");
        sb.Append(" ICD10_3_Code , ICD10_3_Code_Desc ,ICD10_Code , WHO_Full_Desc ,icdp.icd_id,icdp.ID ,Ifnull(icdp.Remarks,'')Remarks,IF(icdp.AddToPatientList='1','Yes','No')AddToPatientList ");
        sb.Append(" FROM cpoe_10cm_patient icdp INNER JOIN icd_10_new icd ON icdp.icd_id=icd.ID where icdp.IsActive=1");
        sb.Append(" AND icd.Isactive=1 AND icdp.TransactionID='" + TID + "' union  ");

        sb.Append(" SELECT REPLACE(icdp.TransactionID,'ISHHI','')'IPD No.',TransactionID,Group_Code ,Group_Desc , ");
        sb.Append(" ICD10_3_Code , ICD10_3_Code_Desc ,ICD10_Code , WHO_Full_Desc ,icdp.icd_id,icdp.ID ,Ifnull(icdp.Remarks,'')Remarks,IF(icdp.AddToPatientList='1','Yes','No')AddToPatientList ");
        sb.Append(" FROM cpoe_10cm_patient icdp INNER JOIN icd_10_new icd ON icdp.icd_id=icd.ID where icdp.IsActive=1 AND icdp.AddToPatientList=1 ");
        sb.Append(" AND icd.Isactive=1 AND icdp.PatientID='" + ViewState["PatientID"].ToString() + "'  ");
        
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            grvICDCode.DataSource = dt;
            grvICDCode.DataBind();
        }
        else
        {
            grvICDCode.DataSource = null;
            grvICDCode.DataBind();

        }
    }
    protected void lbFinalDiagnosis_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/Design/IPD/IPD_FinalDiagnosis.aspx?TransactionID=" + ViewState["TID"].ToString() + "&PatientID=" + ViewState["PatientID"].ToString());
    }
    protected void lbProvisional_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/Design/IPD/IPDPatientProvisionalDiagnosis.aspx?TransactionID=" + ViewState["TID"].ToString() + "&PatientID=" + ViewState["PatientID"].ToString());
    }
}
