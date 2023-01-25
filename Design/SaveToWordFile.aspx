<%@ Page Language="C#" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Data" %>
<%
	try
	{
        //String strImageName;
        Session["DB"] = System.Configuration.ConfigurationManager.AppSettings["LiveDB"];
        if (Request.QueryString["IsTemplate"] == "3")
        {
            StockReports.ExecuteDML("   INSERT INTO word_file (Test_ID,Open_UserID,Open_Date,EntryDate) VALUES('" + Request.QueryString["TestID"].Trim() + "','" + Request.QueryString["UserID"] + "',NOW(),NOW())  ");
        }
        else if (Request.QueryString["IsTemplate"] == "4")
        {
            StockReports.ExecuteDML("   UPDATE word_file SET Close_UserID='" + Request.QueryString["UserID"] + "',Close_Date = NOW() where Test_ID='" + Request.QueryString["TestID"].Trim() + "' ");
        }
        HttpFileCollection files = HttpContext.Current.Request.Files;
        HttpPostedFile uploadfile = files["uploadfile"];
        string FileName = uploadfile.FileName;


       
        
        
        if (Request.QueryString["IsTemplate"].Trim() == "1")
        {
            if (!Directory.Exists(Server.MapPath(".") + "\\Templates"))
            {
                Directory.CreateDirectory(Server.MapPath(".") + "\\Templates");
            }
            uploadfile.SaveAs(Server.MapPath(".") + "\\Templates\\" + Request.QueryString["Template_ID"] + ".doc");
            //update database
            /// new template
            if (Request.QueryString["NewTemplate"].Trim() == "1")
            {
                StockReports.ExecuteDML("insert into investigation_template (Template_ID,Investigation_ID,Temp_Head,Gender,User,UpdateDate) values('" + Request.QueryString["Template_ID"].Trim() + "','" + Request.QueryString["Investigation_ID"] + "','" + Request.QueryString["Temp_Head"] + "','" + Request.QueryString["Gender"] + "','" + Request.QueryString["UserID"] + "',Now())");
                string str = StockReports.ExecuteScalar("SELECT MAX(Template_ID) FROM investigation_template");

                if (Request.QueryString["IsDefaultTemplate"] == "1")
                {
                    StockReports.ExecuteDML("UPDATE investigation_master SET Temp_Id='" + str + "' WHERE Investigation_ID='" + Request.QueryString["Investigation_ID"] + "'");
                }
            }
            else
            {
                if (Request.QueryString["IsDefaultTemplate"] == "1")
                {
                    StockReports.ExecuteDML("UPDATE investigation_master SET Temp_Id='" + Request.QueryString["Template_ID"].Trim() + "' WHERE Investigation_ID='" + Request.QueryString["Investigation_ID"].Trim() + "'");
                }
                StockReports.ExecuteDML(" update investigation_template set Temp_Head='" + Request.QueryString["Temp_Head"] + "',Gender='" + Request.QueryString["Gender"] + "',UpdateDate=NOW(),User='" + Request.QueryString["UserID"] + "' where Template_ID='" + Request.QueryString["Template_ID"].Trim() + "' ");
            }
            
        }
        

        else if(Request.QueryString["IsTemplate"].Trim() == "0")
        {
            if (!Directory.Exists(Server.MapPath(".") + "\\RadiologyReport"))
            {
                Directory.CreateDirectory(Server.MapPath(".") + "\\RadiologyReport");
            }
            uploadfile.SaveAs(Server.MapPath(".") + "\\RadiologyReport\\" + FileName);

            if (Request.QueryString["Approved"].Trim() == "0")
            {
                StockReports.ExecuteDML("update patient_labinvestigation_opd set Approved=0,ApprovedBy='',ApprovedDate=null,ApprovedName='', Result_Flag=1,ResultEnteredDate=now(),LabInves_Description='" + Request.QueryString["Path"].Trim() + "',ResultEnteredBy='" + Request.QueryString["UserID"] + "',ResultEnteredName='" + Request.QueryString["UserName"] + "' where Test_ID='" + Request.QueryString["TestID"].Trim() + "'");
            }
            else
            {
                StockReports.ExecuteDML("UPDATE patient_labinvestigation_opd SET Result_Flag=1,ResultEnteredDate=now(),LabInves_Description='" + Request.QueryString["Path"].Trim() + "',ResultEnteredBy='" + Request.QueryString["UserID"] + "',ResultEnteredName='" + Request.QueryString["UserName"] + "',Approved=1,ApprovedBy='" + Request.QueryString["DoctorID"].Trim() + "',ApprovedDate=now(),ApprovedName='" + Request.QueryString["DoctorName"].Trim() + "' WHERE Test_ID='" + Request.QueryString["TestID"].Trim() + "'");
            }



            //string LabNo = StockReports.ExecuteScalar("Select LedgertransactionNo from patient_labinvestigation_opd  where  Test_ID='" + Request.QueryString["TestID"].Trim() + "'  ");
            //string CenterID = StockReports.ExecuteScalar("Select CentreID from f_ledgertransaction  where  LedgertransactionNo='" + LabNo + "'  ");
            //DataTable dtApproved = StockReports.GetDataTable("SELECT Count(Approved) Approved  FROM patient_labinvestigation_opd WHERE LedgertransactionNo='" + LabNo + "' ");
            //DataTable dtApprovedStatus = StockReports.GetDataTable("SELECT Count(Approved) Approved  FROM patient_labinvestigation_opd WHERE LedgertransactionNo='" + LabNo + "' AND Approved = 1 ");
            //if (dtApproved.Rows[0]["Approved"].ToString() == dtApprovedStatus.Rows[0]["Approved"].ToString())
            //{
            //    string cllprocINSER_SMS = "call INSERT_SMS_Report('" + LabNo + "','" + CenterID + "' ,'" + Request.QueryString["UserID"] + "');";
            //    StockReports.ExecuteDML(cllprocINSER_SMS);
            //}



        }
        
        
        

        
        
        
        
        
        //string TestID = Request.QueryString["TestID"];
        //string LedgerTransactionNo = Request.QueryString["LedgerTransactionNo"];
        //string UserID = Request.QueryString["UserID"];

	}
	catch
	{
	}

%>