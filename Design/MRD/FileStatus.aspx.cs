using System;
using System.Data;
using System.Text;
using System.Web.UI;

public partial class Design_MRD_FileStatus : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
        {
        if (!IsPostBack)
            {
            ViewState["ID"] = Session["ID"].ToString();
            string type = Request.QueryString["Type"].ToString();
            ViewState["Type"] = type.ToString();
            string TransactionID = "";
            string PatientID = Request.QueryString["PatientID"];
            ViewState["PatientID"] = PatientID.ToString();
            //if (ViewState["Type"].ToString() == "IPD")
            //{
                if (Request.QueryString["TID"] == null)
                {
                    return;
                }
                else
                {
                }
                 TransactionID = Request.QueryString["TID"];
                ViewState["TID"] = TransactionID.ToString();
                BindPatientDetail(TransactionID, PatientID);
                BindStatusGrid(TransactionID, "ALL", PatientID);
            }
            //else
            //{
            //    BindPatientDetail(TransactionID,PatientID);
            //    BindStatusGrid(TransactionID, "ALL", PatientID);
            //    }
            //}
        }

    public void BindPatientDetail(string TransactionID, string PatientID)
    {
        string sql="";
        //if (ViewState["Type"].ToString() == "IPD")
        //{
        sql = " select pm.PatientID,pm.PName,IF(pmh.Type<>'IPD','',pmh.TransNo)Transno ,pmh.TransactionID,pmh.BillNo, " +
                                " if(pm.DOB='0001-01-01',pm.Age,date_format(pm.DOB,'%d-%b-%Y')) AGE,pmh.MLC_NO, " +
                                " date_format(pmh.DateOfAdmit,'%d-%b-%Y')DateOfAdmit ,  " +
                                " if(pmh.DateOfDischarge='0001-01-01','', date_format(pmh.DateOfDischarge,'%d-%b-%Y'))DateOfDischarge ,pmh.Type" +
                                " from patient_master pm " +
                                " inner join patient_medical_history pmh on pm.PatientID = pmh.PatientID  " +
                                " where pmh.TransactionID ='" + TransactionID + "' and pmh.CentreID="+Session["CentreID"]+"";
        //}
        //else
        //{
        //    sql = "SELECT   pm.PatientID,  pm.PName,  IF(pm.DOB='0001-01-01',pm.Age,DATE_FORMAT(pm.DOB,'%d-%b-%Y'))    AGE FROM patient_master pm  INNER JOIN patient_medical_history pmh    ON pm.PatientID = pmh.PatientID WHERE pmh.PatientID  = '" + PatientID+"'";
        //}

        DataTable dt = StockReports.GetDataTable(sql);

        if (dt != null && dt.Rows.Count > 0)
        {
            //if (ViewState["Type"].ToString() == "IPD")
            //{
                pnlIpd.Visible = true;
                lblBillNo.Text = Util.GetString(dt.Rows[0]["BillNo"]);
                lblCRNumber.Text = Util.GetString(dt.Rows[0]["Transno"]); 
                lblDischargeDate.Text = Util.GetString(dt.Rows[0]["DateOfDischarge"]);
                lblMLCNo.Text = Util.GetString(dt.Rows[0]["MLC_NO"]);
                lblPatientName.Text = Util.GetString(dt.Rows[0]["PName"]);
                lblPatientType.Text = Util.GetString(dt.Rows[0]["Type"]);

            //}
            //else
            //{
            //    pnlOpd.Visible = true;
            //    lblPnatientnameOpd.Text = Util.GetString(dt.Rows[0]["PName"]);
            //    lblMRno.Text = Util.GetString(dt.Rows[0]["PatientID"]);
            //}
        }
        else
        {
            lblMsg.Text = "Error..";
            return;
        }

       



    }

   
    

    public void BindStatusGrid(string TransactionID, string Status, string PatientID)
    {
        StringBuilder sb =new StringBuilder();
        //if (ViewState["Type"].ToString() == "IPD")
        //{
            if (Status.ToUpper() != "ALL")
            {
                sb.Append("        SELECT mfm.FileID,TransactionID,mfm.PatientID AS PID, ");
                sb.Append("        (SELECT NAME FROM mrd_room_master WHERE RmID=mfm.RmID)RoomName, ");
                sb.Append("        (SELECT NAME FROM mrd_almirah_master WHERE AlmId= mfm.AlmID)Almirah, ");
                sb.Append("        (SELECT NAME FROM mrd_document_master WHERE DocumentID=mfd.DocumentID)Document,mfd.Status,mfs.Description FROM mrd_file_master mfm  ");
                sb.Append("        INNER JOIN mrd_file_detail mfd ON mfm.FileID=mfd.FileID inner join mrd_file_status mfs on mfs.FileStatus=mfd.Status  WHERE mfm.TransactionID='" + TransactionID + "' AND mfd.Status in ('" + Status + "') order by mfd.Status");
            }
            else
            {
                sb.Append("        SELECT mfm.FileID,TransactionID,mfm.PatientID as PID, ");
                sb.Append("        (SELECT NAME FROM mrd_room_master WHERE RmID=mfm.RmID)RoomName, ");
                sb.Append("        (SELECT NAME FROM mrd_almirah_master WHERE AlmId= mfm.AlmID)Almirah, ");
                sb.Append("        (SELECT NAME FROM mrd_document_master WHERE DocumentID=mfd.DocumentID)Document,mfd.Status,mfs.Description FROM mrd_file_master mfm  ");
                sb.Append("        INNER JOIN mrd_file_detail mfd ON mfm.FileID=mfd.FileID inner join mrd_file_status mfs on mfs.FileStatus=mfd.Status WHERE mfm.TransactionID='" + TransactionID + "' order by mfd.Status");

            }
        //}
        //else
        //{
        //    if (Status.ToUpper() != "ALL")
        //    {
        //        sb.Append("        SELECT mfm.FileID,REPLACE(mfm.PatientID,'LSHHI','')PID, ");
        //        sb.Append("        (SELECT NAME FROM mrd_room_master WHERE RmID=mfm.RmID)RoomName, ");
        //        sb.Append("        (SELECT NAME FROM mrd_almirah_master WHERE AlmId= mfm.AlmID)Almirah, ");
        //        sb.Append("        (SELECT NAME FROM mrd_document_master WHERE DocID=mfd.DocID)Document,mfd.Status,mfs.Description FROM mrd_file_master mfm  ");
        //        sb.Append("        INNER JOIN mrd_file_detail mfd ON mfm.FileID=mfd.FileID inner join mrd_file_status mfs on mfs.FileStatus=mfd.Status  WHERE mfm.PatientID='" + PatientID + "' AND mfd.Status in ('" + Status + "') order by mfd.Status");
        //    }
        //    else
        //    {
        //        sb.Append("        SELECT mfm.FileID,REPLACE(mfm.PatientID,'LSHHI','')PID, ");
        //        sb.Append("        (SELECT NAME FROM mrd_room_master WHERE RmID=mfm.RmID)RoomName, ");
        //        sb.Append("        (SELECT NAME FROM mrd_almirah_master WHERE AlmId= mfm.AlmID)Almirah, ");
        //        sb.Append("        (SELECT NAME FROM mrd_document_master WHERE DocID=mfd.DocID)Document,mfd.Status,mfs.Description FROM mrd_file_master mfm  ");
        //        sb.Append("        INNER JOIN mrd_file_detail mfd ON mfm.FileID=mfd.FileID inner join mrd_file_status mfs on mfs.FileStatus=mfd.Status WHERE mfm.PatientID='" + PatientID + "' order by mfd.Status");

        //    }
        //}
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt != null && dt.Rows.Count > 0)
        {
            //grdDocs.DataSource = dt;
            //grdDocs.DataBind();


        }
        else
        {

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM126','" + lblMsg.ClientID + "');", true);
        }
       
    }

    
}
