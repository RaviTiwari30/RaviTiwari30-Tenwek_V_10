<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DisplayBillInProcess.aspx.cs" Inherits="Design_IPD_DisplayBillInProcess" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
    <link rel="Stylesheet" type="text/css" href="../../Scripts/chosen.css" />
    <script type="text/javascript" src="../../Scripts/chosen.jquery.js"></script>
    <script src="../../Scripts/Common.js"></script>
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-ui.js"></script>
    <link href="../../Styles/jquery-ui.css" rel="stylesheet" />
    <style type="text/css">
        table {
        font-weight:bold;
        font-size:20px;
        }
        body {
        background-color:lightyellow;
        }

        table {
           
  position: relative;
  border-collapse: collapse; 
        }
        th, td {
  padding: 0.25rem;
  border:1px solid lightgray;
}
tr.headcol th {
  background: #145b8a;
  color: white;
}
/*tr.green th {
  background: green;
  color: white;
}*/
/*tr.purple th {
  background: purple;
  color: white;
}*/
th {
  position: sticky;
  top: 0; /* Don't forget this, required for the stickiness */
  box-shadow: 0 2px 2px -1px rgba(0, 0, 0, 0.4);
  background-color:#145b8a;
}
    </style>
    <script type="text/javascript">
        $(document).ready(function () {
            bindAllBillProcess();

            var refreshId = setInterval(function () {
                bindAllBillProcess();
            },120000);
        });
        function bindAllBillProcess() {
            serverCall('DisplayBillInProcess.aspx/BindAllBillInProcess', {}, function (response) {
                responseData = JSON.parse(response);
                //$("#tbodyPending").empty();
                //if (responseData != '') {
                //    for (var i = 0; i < responseData.length; i++) {
                //        if (responseData[i].IsAbsent == 0)
                //            $("#tbodyPending").append("<tr id='trData'><td style='text-align:left;width:25%;'>Waiting</td><td style='text-align:left;width:55%;'>" + responseData[i].PatientName + "</td><td style='text-align:center;width:20%;'>" + responseData[i].ExaminationTokenNo + "</td></tr>");
                //        else
                //            $("#tbodyPending").append("<tr id='trData' style='background-color:yellow;'><td style='text-align:left;width:25%;'>Waiting</td><td style='text-align:left;width:55%;'>" + responseData[i].PatientName + "</td><td style='text-align:center;width:20%;'>" + responseData[i].ExaminationTokenNo + "</td></tr>");
                //    }
                //}

                var divDisplayMapping = $('#divDisplayMapping');
                templateData = responseData;
                var parseHTML = $('#templateDisplayMapping').parseTemplate(templateData);
                divDisplayMapping.html(parseHTML);
            });
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <div style="text-align: center; font-weight: bold; font-size: 50px; background-color: #dde0f7;">
               <span style="text-shadow:2px 2px 2px #4a4848;"> BILL IN PROCESS STATUS</span>
            </div>
            <br />
            <div class="row">
                <div class="col-md-24" style="height: 830px;">
                    <table style="width:100%;">
                        <thead>
                            <tr style="background-color: #145b8a; color: white;">
                                <th style="width: 5.7%;border:1px solid;" class="headcol">SR. No.
                                </th>
                                <th style="width: 7.3%;border:1px solid;" class="headcol">IPD No.
                                </th>
                                <th style="width: 39.5%;border:1px solid;" class="headcol">PATIENT NAME
                                </th>
                                <th style="width: 18.5%;border:1px solid; text-align: center;" class="headcol">Doctor
                                </th>
                                <th style="width: 14%;border:1px solid;" class="headcol">Panel
                                </th>
                                <th style="width: 17%;border:1px solid;" class="headcol">Bed No.
                                </th>
                                <th style="width: 20%;border:1px solid; text-align: center;" class="headcol">Status
                                </th>
                            </tr>
                        </thead>
                    </table>
                    <marquee id="marqueeData" direction="up" height="650px" behaviour="slide" scrollamount="4">
                    <div id="divDisplayMapping"></div>
                        </marquee>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
<script type="text/html" id="templateDisplayMapping">
    
    <table style="width: 100%; border: 1px solid lightgray;" id="tblProcessDisply">
        <tbody>
            
                <#
		var dataLength=templateData.length;
		window.status="Total Records Found :"+ dataLength;
		var objRow;
		var status;
		for(var j=0;j<dataLength;j++)
		{
		objRow = templateData[j];
		#>
                <tr class="">
                    <td id="tdIndex" class="GridViewLabItemStyle" style="text-align:center;width: 8%;"><#=j+1#></td>
                    <td id="tdIPDNO" class="GridViewLabItemStyle" style="text-align:center;width: 10%;"><#=objRow.TransactionID#></td>
                    <td id="tdPatientName" class="GridViewLabItemStyle" style="text-align:center;width: 55%;"><#=objRow.PName#></td>
			        <td id="tdDoctorName" class="GridViewLabItemStyle" style="text-align:center;width: 20%; "><#=objRow.DoctorName#></td>
	    		   <td id="tdPanel" class="GridViewLabItemStyle" style="text-align:center;width: 25%;"><#=objRow.Panel#></td>
                    <td id="tdBedNo" class="GridViewLabItemStyle" style="text-align:center;width: 55%;"><#=objRow.BedNo#></td>
                    <#if(objRow.IsBillFreezed=="1"){#>
			        <td id="tdBillFreez" class="GridViewLabItemStyle" style="text-align:center;background-color:lightgreen;width: 20%; ">Bill Prepared</td>
                    <#}else{ #>
                    <td id="tdBillFreez" class="GridViewLabItemStyle" style="text-align:center;background-color:red;width: 20%; ">Bill In Process</td>
                    <#} #>
				</tr>   

			<#}#>
        </tbody>
                    </table>
</script>
