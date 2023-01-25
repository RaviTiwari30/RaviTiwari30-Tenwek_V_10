using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Mortuary_AddFreezer : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
       
    }

    protected void btnSaveFloor_Click(object sender, EventArgs e)
    {
        try
        {
            if (Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM floor_master WHERE NAME='" + txtFloorName.Text.Trim() + "'")) > 0)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM163','lblErrorMsg');", true);
                return;
            }
            StockReports.ExecuteDML("INSERT INTO floor_master(NAME,SequenceNo)VALUES('" + txtFloorName.Text.Trim().Replace("'", "''") + "','" + ddlSequenceNo.SelectedItem.Value + "')");
            txtFloorName.Text = "";
            ddlSequenceNo.SelectedIndex = 0;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','lblErrorMsg');", true);
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "$('#lblErrorMsg').text('"+ex.Message+"');", true);
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }
}