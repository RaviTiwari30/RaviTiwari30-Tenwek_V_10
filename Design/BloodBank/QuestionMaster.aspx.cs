using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_BloodBank_QuestionMaster : System.Web.UI.Page
{
    protected void btncancel_Click(object sender, EventArgs e)
    {
        txtQuestion.Text = "";
        btnSave.Visible = true; ;
        btnUpdate.Visible = false;
        btnCancel.Visible = false;
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (ValidateQuestion(txtQuestion.Text))
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                Question_Master qm = new Question_Master(tranX);
                qm.Question = txtQuestion.Text;
                qm.Type = rblType.SelectedItem.Value;
                qm.IsActive = Util.GetInt(rblActive.SelectedItem.Value);
                qm.CreatedBy = Session["ID"].ToString();
                if (chkSelected.Checked)
                    qm.Flag = 1;
                else
                    qm.Flag = 0;
                qm.Insert();

                tranX.Commit();
               
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblmsg.ClientID + "');", true);
                BindData();
                Clear();
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM07','" + lblmsg.ClientID + "');", true);
                ClassLog c1 = new ClassLog();
                c1.errLog(ex);
                tranX.Rollback();
                
            }
            finally
            {
                tranX.Dispose();
                con.Close();
                con.Dispose();
            }
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM225','" + lblmsg.ClientID + "');", true);
        }
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        try
        {
            if (txtQuestion.Text != "")
            {
                string Query = "update bb_questions_master set Question='" + txtQuestion.Text.Trim() + "',Type='" + rblType.SelectedItem.Value + "' ,IsActive='" + rblActive.SelectedItem.Value + "'  where Id='" + ViewState["Id"].ToString() + "' ";
                StockReports.ExecuteDML(Query);
                //ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('Question Updated Sucessfully...');", true);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM02','" + lblmsg.ClientID + "');", true);
                BindData();
                Clear();
                btnSave.Visible = true; ;
                btnUpdate.Visible = false; ;
                btnCancel.Visible = false;
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM225','" + lblmsg.ClientID + "');", true);
            }
        }
        catch (Exception ex)
        {
            ClassLog c1 = new ClassLog();
            c1.errLog(ex);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM07','" + lblmsg.ClientID + "');", true);
        }
    }

    protected void Clear()
    {
        txtQuestion.Text = "";
        rblActive.SelectedIndex = 0;
        rblType.SelectedIndex = 0;
    }

    protected void grdQuestions_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        
        if (e.NewPageIndex == -1)
        {
        }
        else
        {
            grdQuestions.PageIndex = e.NewPageIndex;
        }
        BindData();
    }

    protected void grdQuestions_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            e.Row.ToolTip = "Question: " + Convert.ToString(DataBinder.Eval(e.Row.DataItem, "Question"));
            e.Row.Style.Add("Cursor", "Hand");

            e.Row.Attributes["onmouseover"] = "javascript:SetMouseOver(this)";
            e.Row.Attributes["onmouseout"] = "javascript:SetMouseOut(this)";
            //e.Row.Attributes.Add("onmouseover", "this.style.backgroundColor='#fafad2'");

            //e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor='#afeeee'");
        }
    }

    protected void grdQuestions_SelectedIndexChanged(object sender, EventArgs e)
    {
        lblmsg.Text = "";
        btnSave.Visible = false;
        btnUpdate.Visible = true;
        btnCancel.Visible = true;
        string[] s = ((Label)grdQuestions.SelectedRow.FindControl("lblrecord")).Text.Split('#');
        ViewState["Id"] = s[0].ToString();

        txtQuestion.Text = s[1].ToString();
        if (s[2].ToString() == "Radio")
        {
            rblType.SelectedIndex = 0;
        }
        else
        {
            rblType.SelectedIndex = 1;
        }
        if (Util.GetInt(s[3].ToString()) == 1)
        {
            rblActive.SelectedIndex = 0;
        }
        else
        {
            rblActive.SelectedIndex = 1;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtQuestion.Focus();
            btnSave.Visible = true; ;
            btnUpdate.Visible = false; ;
            btnCancel.Visible = false;
            BindData();
        }
    }

    protected bool ValidateQuestion(string Question)
    {
        int i = Util.GetInt(StockReports.ExecuteScalar("select count(*) from bb_questions_master where Question='" + Question + "'"));
        if (i > 0)
        { return false; }
        else
        { return true; }
    }

    private void BindData()
    {
        DataTable dt = StockReports.GetDataTable("select Id,Question,if(Type='r','Radio','Text')Type,IsActive from bb_questions_master ");
        if (dt.Rows.Count > 0)
        {
            grdQuestions.DataSource = dt;
            grdQuestions.DataBind();
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblmsg.ClientID + "');", true);
            grdQuestions.DataSource = null;
            grdQuestions.DataBind();
        }
    }
}