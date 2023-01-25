using System;
using System.Data;
using System.Text;
using System.Web.UI;

public partial class Design_MRD_SearchMRD : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoaddate_MRD.BindRo(ddlroomname);
        }
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        search();
    }

    private void search()
    {
        lblMsg.Text = "";
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT mfm.TransactionID,pm.PName,pm.PLastName,pm.PFirstName,mrm.Name roomname,mam.Name rackname,mlm.ShelfNo,mfm.PatientID,mam.AlmID,  mfm.CurPos FROM mrd_room_master mrm");
        sb.Append("  INNER JOIN  mrd_almirah_master mam ON mrm.RmID=mam.RmID");
        sb.Append("   INNER JOIN mrd_location_master mlm ON mlm.RmID=mrm.RmID AND mlm.AlmID = mam.AlmID");
        sb.Append("  LEFT OUTER JOIN mrd_file_master mfm ON mrm.RmID=mfm.RmID AND mfm.AlmID=mam.AlmID AND mfm.ShelfNo=mlm.ShelfNo");
        sb.Append("  inner JOIN  patient_master pm ON pm.PatientID=mfm.PatientID WHERE mfm.PatientID<>''   AND mfm.IsIssued=0");

        if (txtMrno.Text.Trim() != "")
        {
            sb.Append("  And pm.PatientID='" + txtMrno.Text + "'");
        }
        if (txtPatientName.Text.Trim() != "")
        {
            sb.Append(" And pm.PName like '%" + txtPatientName.Text.Trim() + "%'");
        }
        if (ddlroomname.SelectedItem.Text != "All")
        {
            sb.Append("  And mrm.Name  ='" + ddlroomname.SelectedItem.Text + "'");
            if (ddlrack.SelectedItem.Text != "All")
            {
                sb.Append("  and mam.Name ='" + ddlrack.SelectedItem.Text + "'");
                if (ddlshelf.SelectedItem.Text != "All")
                {
                    sb.Append(" and mlm.ShelfNo ='" + ddlshelf.SelectedItem.Text + "'");
                }
            }
        }
        sb.Append("  AND mlm.CentreID="+Session["CentreID"]+" Order by pm.PLastName");
        DataTable dtMRD = StockReports.GetDataTable(sb.ToString());
        if (dtMRD.Rows.Count > 0)
        {
            grdMRD.DataSource = dtMRD;
            grdMRD.DataBind();
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('No Record Found',function(){});", true);
            grdMRD.DataSource = null;
            grdMRD.DataBind();
        }
    }

    protected void ddlroomname_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindAlmirah(Util.GetString(ddlroomname.SelectedItem.Value));
    }

    public void BindAlmirah(string RmID)
    {
        string sql = " select distinct lm.AlmID, am.Name from mrd_location_master lm inner join  mrd_almirah_master am on am.AlmID=lm.AlmID where lm.MaxPos >= (CurPos+AdditionalNo) and am.RmID='" + RmID + "' order by am.Name ";
        DataTable dt = StockReports.GetDataTable(sql);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlrack.DataSource = dt;
            ddlrack.DataTextField = "Name";
            ddlrack.DataValueField = "AlmID";
            ddlrack.DataBind();
            ddlrack.Items.Insert(0, "All");
            //BindShelf(Util.GetString(dt.Rows[0]["AlmID"]));
        }
        else
        {
            ddlrack.DataSource = null;
            ddlrack.DataBind();
            ddlshelf.SelectedIndex = -1;
            ddlrack.SelectedIndex = -1;
            ddlrack.Controls.Clear();
            ddlrack.Items.Clear();
            ddlshelf.Items.Clear();
            ddlshelf.Controls.Clear();
            ddlshelf.DataSource = null;
            ddlshelf.DataBind();
            ddlrack.Items.Insert(0, "All");
            ddlshelf.Items.Insert(0, "All");
        }
    }

    public void BindShelf(string AlmID)
    {
        if (AlmID.ToString() != "All")
        {
            string sql = " select distinct ShelfNo,concat(ShelfNo,'$',ifnull(CurPos,0))ID from mrd_location_master  where AlmID = '" + AlmID + "' and  MaxPos >= (CurPos+AdditionalNo) and isactive=1 order by ShelfNo ";
            DataTable dt = StockReports.GetDataTable(sql);

            if (dt != null && dt.Rows.Count > 0)
            {
                ddlshelf.DataSource = dt;
                ddlshelf.DataTextField = "ShelfNo";
                ddlshelf.DataValueField = "ID";
                ddlshelf.DataBind();
                ddlshelf.Items.Insert(0, "All");
            }
            else
            {
                ddlshelf.DataSource = null;
                ddlshelf.DataBind();
                ddlshelf.SelectedIndex = -1;
                ddlshelf.Controls.Clear();
                ddlshelf.Items.Insert(0, "Select");
            }
        }
    }

    protected void cmbAlmirah_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindShelf(Util.GetString(ddlrack.SelectedItem.Value));
    }
}