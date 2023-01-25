using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Web.UI.WebControls;

public partial class Design_EDP_ApprovalTypeMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindDepartment();
            BindHeader();
        }
    }

    public void BindDepartment()
    {
        DataTable dt = StockReports.GetDataTable("SELECT Distinct tm.NAME as Department,tm.ID FROM type_master tm inner join Doctor_master Dm on Dm.DocDepartmentID=tm.ID  WHERE TypeID =5 ORDER BY tm.NAME");
        if (dt.Rows.Count > 0)
        {
            ddlDepartment.DataSource = dt;
            ddlDepartment.DataValueField = "ID";
            ddlDepartment.DataTextField = "Department";
            ddlDepartment.DataBind();
        }
        else
            ddlDepartment.DataSource = null;
        ddlDepartment.Items.Insert(0, "Select");
    }

    public void BindHeader()
    {
        //DataTable dt = StockReports.GetDataTable("SELECT header_id,dh.HeaderName,dh.SeqNo FROM d_discharge_header dh WHERE isactive=1 ORDER BY HeaderName");
        DataTable dt = StockReports.GetDataTable("SELECT IF(dd.id IS NULL,'false','true')chk,dh.header_id,dh.HeaderName,IF(dd.id IS NULL,dh.SeqNo,dd.SeqNo)SeqNo FROM d_discharge_header dh LEFT JOIN d_Header_DeptWise dd ON dd.Header_Id=dh.Header_Id AND dd.Department='" + ddlDepartment.SelectedItem.Value + "' AND dd.IsActive=1 WHERE dh.isactive=1 ORDER BY HeaderName");
        if (dt != null && dt.Rows.Count > 0)
        {
            grdHeader.DataSource = dt;
            grdHeader.DataBind();
        }
        else
        {
            grdHeader.DataSource = null;
            grdHeader.DataBind();
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        string str = "", Header_Id = "", HeaderName = "", SeqNo = "";
        int isActive = 0;
        CheckBox chk;
        DataTable dt;
        if (ddlDepartment.SelectedIndex == 0)
        {
            lblMsg.Text = "Kindly select Department";
            return;
        }
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            foreach (GridViewRow gv in grdHeader.Rows)
            {
                Header_Id = ((Label)gv.FindControl("lblHeaderId")).Text;
                HeaderName = ((Label)gv.FindControl("lblHeaderName")).Text;
                SeqNo = ((TextBox)gv.FindControl("txtSeqNo")).Text;
                chk = (CheckBox)gv.FindControl("chkheader");
                if (chk.Checked)
                    isActive = 1;
                else
                    isActive = 0;

                dt = StockReports.GetDataTable("select * from d_Header_DeptWise where Department='" + ddlDepartment.SelectedItem.Value + "' and Header_Id=" + Header_Id + "");
                if (dt != null && dt.Rows.Count > 0)
                {
                    str = "Update d_Header_DeptWise set IsActive=" + isActive + ", SeqNo=" + SeqNo + ",UpdatedBy='" + Session["Id"].ToString() + "',UpdatedOn='" + Util.GetDateTime(DateTime.Now).ToString("yyyy-MM-dd HH:mm:ss") + "' where Department='" + ddlDepartment.SelectedItem.Value + "' and Header_Id=" + Header_Id + "";
                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str.ToString());
                }
                else if (chk.Checked)
                {
                    str = "INSERT INTO d_Header_DeptWise(Department,Header_Id,HeaderName,SeqNo,CreatedBy)VALUES( " +
                          " '" + ddlDepartment.SelectedItem.Value + "','" + Header_Id + "','" + HeaderName + "','" + SeqNo + "','" + Session["Id"].ToString() + "')";
                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str.ToString());
                }
            }

            Tnx.Commit();
           
            lblMsg.Text = "Record saved";
            BindDepartment();
            BindHeader();
        }
        catch (Exception ex)
        {
            Tnx.Rollback();
           
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            lblMsg.Text = "Error";
        }
        finally
        {
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void ddlDepartment_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindHeader();
    }

   
}