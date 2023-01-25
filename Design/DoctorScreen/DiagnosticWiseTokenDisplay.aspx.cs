using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;

public partial class Design_DoctorScreen_DiagnosticWiseTokenDisplay : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) {
            BindUser();
        }
    }

    private void BindUser()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT id,roomname FROM sampleCollectionRoomMaster WHERE isactive=1 and CentreID = " + Util.GetInt(Session["CentreID"]) + "");
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            cblUser.DataSource = dt;
            cblUser.DataTextField = "roomname";
            cblUser.DataValueField = "id";
            cblUser.DataBind();
        }
    }

    private string GetSelection(CheckBoxList cbl)
    {
        string str = string.Empty;

        foreach (ListItem li in cbl.Items)
        {
            if (li.Selected)
            {
                // %27 is used to replace single code ('). Otherwise window.open function will not work. 
                if (str != string.Empty)
                    str += ",%27" + li.Text + "%27";
                else
                    str = "%27" + li.Text + "%27";
            }
        }

        return str;
    }

    protected void btnPreview_Click(object sender, EventArgs e)
    {
        string user = GetSelection(cblUser) ;
        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/DoctorScreen/DiagnosticwiseTokenDisplayScreen.aspx?RoomName= "+user+" ');", true);
    }
}