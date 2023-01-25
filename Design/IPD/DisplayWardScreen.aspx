<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DisplayWardScreen.aspx.cs" Inherits="Design_IPD_DisplayWardScreen" %>

<!DOCTYPE html>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="asp" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
      <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
    <script src="../../Scripts/jquery.extensions.js" type="text/javascript"></script>
    <script src="../../Scripts/Common.js" type="text/javascript"></script>
     <style type="text/css">
         .Doctor {
             background-color: orange;
             font-size: 145%;
             text-align: left;
             color: white;
             font-family: "Times New Roman", Times, serif;
         }

         .SelectedDoctor {
             background-color: green;
             font-size: 195%;
             text-align: left;
             color: white;
             font-family: "Times New Roman", Times, serif;
         }

         .tbPatient {
             background-color: #436363;
             text-align: left;
             width: 100%;
         }

         .trPatient {
             background-color: Red;
             text-align: left;
             color: white;
             font-size: 220%;
         }

         th {
             background-color: #2C5A8B;
             color: white;
             font-size: 125%;
         }

         .hideDoctor {
             display: none;
         }
     </style>
    <script type="text/javascript">
        $(document).ready(function () {
            BindData();
        });
        function BindData() {
            var Id = "";
            var DptID = "";
            var WardID = '<%=Util.GetString(Request.QueryString["WardID"])%>';
            if (WardID != null && WardID != "") {
                var length = WardID.split(',').length;
                if (length > 1) {
                    for (var i = 0; i < WardID.split(',').length; i++) {
                        id = WardID.split(',')[i];
                        DptID += "'" + id + "',";
                    }
                    WardID = DptID.slice(0, -1);
                }
                else {
                    WardID = "'" + WardID + "'";
                }
            }
            $.ajax({
                url: "DisplayWardScreen.aspx/BindWardData",
                data: '{WardID:"' + WardID + '"}',
                type: "POST",
                contentType: "application/json;charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    if (result.d != "") {
                        Doctor_Data = jQuery.parseJSON(result.d);
                        DoctorID_Current = Doctor_Data[0].DocID;
                        var output = $('#tb_PatientLabSearch').parseTemplate(Doctor_Data);
                        $('#div_Doctor').html(output).customFixedHeader();
                    }
                    else {
                        $('#div_Doctor').html('');
                    }
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
        window.setTimeout(function () {
            $('[id$=div_Doctor]').get(0).scrollTop += 1;
            setTimeout(arguments.callee, 100);
        }, 100);

        jQuery(function ($) {
            var h = window.innerHeight;
            $('[id$=div_Doctor]').on('scroll', function () {
                if ($(this).scrollTop() + $(this).innerHeight() >= $(this)[0].scrollHeight) {
                    $('[id$=div_Doctor]').scrollTop(0)
                }
            })
        });
        window.setInterval(function () {
            BindData();
        }, 10000);
    </script>
         
</head>

<body style="font-family: Georgia; overflow: hidden; margin: 0px;">
    <form id="form1" runat="server">
        <div>
             <asp:ScriptManager ID="ScriptManager1" runat="server">
            </asp:ScriptManager>
             <table style="text-align: center; width: 100%">
                <tr>
                    <td></td>
                </tr>
                <tr>
                    <td style="text-align: left; vertical-align: top;">
                        <div id="div_Doctor" style="overflow-y: scroll; height: 600px;float: left; width: 100%;">
                        </div>
                    </td>
                </tr>
            </table>
        </div>
          <script id="tb_PatientLabSearch" type="text/html">
                   <table  id="tbl_Doctors" style="width:100%;" class="tbPatient"  border="0">
                      <thead>
                         <tr>
                            <th style="text-align:left;width:5%;">S.No.</th>
                            <th style="text-align:left;width:10%;">Admit Date</th>
				            <th style="text-align:left;width:10%;">UHID</th>
				            <th style="text-align:left;width:5%;">IPD No.</th>
				            <th style="text-align:left;width:10%;">Patient Name</th>
				            <th style="text-align:left;width:10%;">Age/Sex</th>
				            <th style="text-align:left;width:10%;">Doctor</th>
				            <th style="text-align:left;width:10%;">Panel</th>
				            <th style="text-align:left;width:10%;">Room Name</th>
                            <th style="text-align:left;width:10%;">Ward Name</th>
                            <th style="text-align:left;width:10%;">Admitted By</th>
                         </tr> 
                      </thead>
                     <tbody>
                         <#
                          var dataLength=Doctor_Data.length;        
                          var objRow;   
                          for(var j=0;j<dataLength;j++)
                          {                
                           objRow = Doctor_Data[j];                       
                         #>                       
                         <tr class="Doctor">
                            <td  id="tdSerial" style="width:5%;text-align:center;"><#=j+1#></td>
                            <td  id="tdAdmitDateTime" style="width:10%;text-align:left;"><#=objRow.AdmitDate#></td>
				            <td  id="tdPatientID"  style="width:10%;text-align:left;"  ><#=objRow.PatientID#></td>
				            <td  id="tdIPDNo" style="width:5%;text-align:left;" ><#=objRow.IPDNO#></td>
				            <td  id="tdPName" style="width:10%;text-align:left;" ><#=objRow.PName#></td>
				            <td  id="tdSex" style="width:10%;text-align:left;" ><#=objRow.AgeSex#></td>
				            <td  id="tdDoctor" style="width:20%;text-align:left;" ><#=objRow.DName#></td>
				            <td  id="tdPanel" style="width:10%;text-align:left;" ><#=objRow.Company_Name#></td>
				            <td  id="tdRoom" style="width:10%;text-align:left;" ><#=objRow.RoomName#></td>
                            <td  id="td1" style="width:10%;text-align:left;" ><#=objRow.BillingCategory#></td>
                            <td  id="tdAdmittedBy" style="width:10%;text-align:left;"><#=objRow.AdmittedBy#></td>          
                        </tr>                       
                        <#}                        
                        #>
                    </tbody>
                  </table>
              </script>
    </form>
</body>
</html>
