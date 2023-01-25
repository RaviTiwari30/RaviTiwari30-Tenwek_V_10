using System;
using System.Data;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_EMR_Doctor_FooterMaster : System.Web.UI.Page
{
    private string str1 = "";

    protected void btnSaveText_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string creator = Session["ID"].ToString();

            //string text = string.Empty;

            //text = txtEditor.Text;
            //text = text.Replace("\'", "\''");
            //text = text.Replace("–", "-");
            //text = text.Replace("'", "'");
            //text = text.Replace("µ", "&micro;");

            txtEditor.Text = txtEditor.Text.Replace("'", " ");
            if (txtEditor.Text == "<br>")
                txtEditor.Text = txtEditor.Text.Replace("<br>", "");
            else if (txtEditor.Text == "<BR>")
                txtEditor.Text = txtEditor.Text.Replace("<BR>", "");
            else if (txtEditor.Text == " <br> ")
                txtEditor.Text = txtEditor.Text.Replace(" <br> ", "");
            else if (txtEditor.Text == " <BR> ")
                txtEditor.Text = txtEditor.Text.Replace(" <BR> ", "");
            string str = "";

            if (chkTemp.Checked)
            {
                str = " insert into f_DoctorFooter(Footer_Desc,CreatorID,Footer_Date,Footer_Head)value('" + txtEditor.Text + "','" + creator + "',NOW(),'" + txtTemplate.Text + "')";
                string insert1 = StockReports.ExecuteScalar(str.ToString());
            }
            else
            {
                if (ddlTemplate.SelectedIndex > 0)
                {
                    str = " update f_DoctorFooter Set Footer_Desc='" + txtEditor.Text + "',CreatorID='" + creator + "',Footer_Head='" + txtTemplate.Text + "' where ID='" + ddlTemplate.SelectedItem.Value + "'";
                    string update = StockReports.ExecuteScalar(str.ToString());

                }
                
            }

            string TransactionId = Request.QueryString["TransactionID"];
            String count1 = "select count(*) from f_patientdoctorfooter where TransactionID='" + TransactionId + "'";
            string count2 = StockReports.ExecuteScalar(count1.ToString());
            string str2 = "";
            if (count2 == "0")
            {
                str2 = "insert into f_patientdoctorfooter(TransactionID,Templetes)values('" + TransactionId + "','" + txtEditor.Text + "')";
                StockReports.ExecuteScalar(str2.ToString());
            }
            else
            {
                str2 = "update f_patientdoctorfooter set Templetes='" + txtEditor.Text + "'where TransactionID='" + TransactionId + "'";
                StockReports.ExecuteScalar(str2.ToString());
            }

            tnx.Commit();

            lblMsg.Text = "Record Saved Successfully";
            chkTemp.Checked = false;
            Bind_ddlFooter();
            txtTemplate.Text = string.Empty;
            txtTemplate.Visible = false;
            txtEditor.Text = "";
        }
        catch (Exception ex)
        {
            lblMsg.Text = "Record Not Saved.";
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

    protected void chkTemp_CheckedChanged(object sender, EventArgs e)
    {
        txtTemplate.Visible = chkTemp.Checked;
    }

    protected void ddlTemplate_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlTemplate.SelectedIndex > 0)
        {
            string str = "select Footer_Desc,Footer_Head from f_doctorfooter where ID=" + ddlTemplate.SelectedValue;
            DataTable dt = StockReports.GetDataTable(str);
            txtEditor.Text = Server.HtmlDecode(Util.GetString(dt.Rows[0]["Footer_Desc"]));
            lblTemplate.Visible = true;
            txtTemplate.Visible = true;
            txtTemplate.Text = dt.Rows[0]["Footer_Head"].ToString();
            lblMsg.Text = "";
        }
        else
        {
            txtEditor.Text = "";
            txtTemplate.Text = "";
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            lblMsg.Text = "";
            Bind_ddlFooter();

            string TransactionId = Request.QueryString["TID"];
            str1 = "select Templetes from f_patientdoctorfooter where TransactionID='" + TransactionId + "'";

            txtEditor.Text = StockReports.ExecuteScalar(str1);
        }
    }

    private void Bind_ddlFooter()
    {
        string Footer = "SELECT ID,Footer_Head FROM f_DoctorFooter";
        DataTable dtFooter = StockReports.GetDataTable(Footer);
        if (dtFooter != null && dtFooter.Rows.Count > 0)
        {
            lblTemplate.Visible = true;
            ddlTemplate.Visible = true;
            ddlTemplate.DataSource = dtFooter;
            ddlTemplate.DataTextField = "Footer_Head";
            ddlTemplate.DataValueField = "ID";
            ddlTemplate.DataBind();
            ddlTemplate.Items.Insert(0, new ListItem("------", "0"));
        }
        else
        {
            ddlTemplate.Items.Clear();
            lblTemplate.Visible = false;
            ddlTemplate.Visible = false;
        }
    }
}