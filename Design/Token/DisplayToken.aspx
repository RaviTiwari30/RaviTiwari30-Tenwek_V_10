<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DisplayToken.aspx.cs" Inherits="Design_Token_DisplayToken" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="asp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
    <script src="../../Scripts/jquery.extensions.js" type="text/javascript"></script>
    <script src="../../Scripts/Common.js" type="text/javascript"></script>
    <style type="text/css">
        .Doctor {
            background-color: orange;
            font-size: 195%;
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
            font-size: 205%;
        }

        .hideDoctor {
            display: none;
        }
    </style>
    <script type="text/javascript">
        var DoctorID_Current = "";
        var Doctor_Data = "";
        var Patient_Data = "";
        var Patient_Start = 0;
        var dtSelect = '<%=DateTime.Now.ToString("yyyy-MM-dd") %>';
        var No_of_Display = 5;
        $(document).ready(function () {
            loadDoctors();
        });
        window.setInterval(function () {
            loadDoctors();
            //timedCount();
        }, 4000);
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
        function loadDoctors() {
            var docDepartmentID = '<%=Util.GetString(Request.QueryString["docDepartmentID"])%>';
            $.ajax({
                url: "Services/token.asmx/LoadDoctor",
                data: '{docDepartmentID:"' + docDepartmentID + '"}',
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
                        //$('#div_Doctor').html(output);
                        $('#div_Doctor').html(output).customFixedHeader();
                        //loadPatient();
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
        //function loadPatient() {
        //    $.ajax({
        //        url: "Services/token.asmx/LoadPatient",
        //        data: '{DocID:"' + DoctorID_Current + '"}',
        //        type: "POST",
        //        contentType: "application/json;charset=utf-8",
        //        timeout: 120000,
        //        dataType: "json",
        //        async: false,
        //        success: function (result) {
        //            Patient_Data = jQuery.parseJSON(result.d);
        //            Patient_Start = 0;
        //            var output = $('#tb_PatientList').parseTemplate(Patient_Data);
        //            $('#div_Patient').html(output);
        //        },
        //        error: function (xhr, status) {
        //            window.status = status + "\r\n" + xhr.responseText;
        //        }
        //    });
        //}
        //function timedCount() {
        //    if (Patient_Start >= 0) {
        //        var output = $('#tb_PatientList').parseTemplate(Patient_Data);
        //        $('#div_Patient').html(output);
        //    }
        //    else {
        //        var newDoctor = $('#tbl_Doctors').find('tr.SelectedDoctor').next('tr').attr('id');
        //        if (newDoctor != null) {
        //            $('#td_' + newDoctor.split('_')[1]).attr('class', 'SelectedDoctor');
        //            $('#td_' + DoctorID_Current).attr('class', 'hideDoctor');
        //            DoctorID_Current = newDoctor.split('_')[1];
        //            loadPatient();
        //        }
        //        else {
        //            loadDoctors();
        //        }
        //    }
        //}
    </script>
    <script type="text/javascript">
        window.setInterval(BlinkIt, 500);
        var color = "#08298A";
        function BlinkIt() {
            var blink = document.getElementById("blink");
            color = (color == "#08298A") ? "#AEB404" : "#08298A";
            blink.style.color = color;
            $('[id$=blink2]').css("color", color);
        }
    </script>
</head>
<body style="font-family: Georgia; overflow: hidden; margin: 0px;">
    <form id="form1" runat="server">
        <div>
            <label id="lblCount"  style="display:none;"></label>
            <asp:ScriptManager ID="ScriptManager1" runat="server">
            </asp:ScriptManager>
         <%--   <div style="text-align: center">
                <%-- <asp:Image ID="imgClientLogo"   runat="server" />
            </div>--%>
            <table style="text-align: center; width: 100%">
                <tr>
                    <td></td>
                </tr>
                <tr>
                    <td style="text-align: left; vertical-align: top;">
                        <div id="div_Doctor" style="overflow-y: scroll; height: 600px;float: left; width: 100%;">
                        </div>
                        <div id="div_Patient" style="float: right; width: 40%;display:none;">
                            <table border="1" class="tbPatient">
                            </table>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
         <script id="tb_PatientLabSearch" type="text/html">
                        <table id="tbl_Doctors" class="tbPatient" border="0">
                            <thead>
                         <tr>
                           <th style="text-align:left">Department</th>
                           <th style="text-align:left">Doctor</th>
                           <th style="text-align:left">Room No.</th>   
                           <th style="text-align:left">Patient Name</th>
                            <th style="text-align:center">Token No.</th> 
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
                        <tr id="td_<#=objRow.DocID#>"<#if(j==0){#>class="SelectedDoctor"<#} else 
                                {#> 
                                  <# if(Doctor_Data[j].DocID==Doctor_Data[j-1].DocID){ #> class="Doctor"
                            <#}else{ #>
                            class="SelectedDoctor"
                            <#}#>
                            class="Doctor"
                             <#}#>
                            >
                         <td  style="width:17%;text-align:left;"><#= objRow.Department.toProperCase() #></td>
                         <td style="width:23%;text-align:left;"><#=objRow.DocName.toProperCase() #></td>                       
                         <td style="width:20%;text-align:left;"><#=objRow.Room_No.toProperCase() #></td>
                         <td style="width:20%;text-align:left;"><#=objRow.PName.toProperCase() #></td>
                       <%--<# if(j!=0){#>
                            <td style="text-align:center;"><#=objRow.TokenNo.toProperCase() #></td>
                           <#} 
                            else
                            {#>
                            <td style="text-align:center;" id="blink">
                                <#=objRow.TokenNo.toProperCase() #>&nbsp; 
                                <label runat="server" id="Label1" style="font-size:18pt;display:block">Proceed To Doctor Room </label>
                            </td>
                            <# }
                            #>--%>
                                <#if(j==0){#>
                             <td style="text-align:center;" id="blink">
                                <#=objRow.TokenNo.toProperCase() #>&nbsp; 
                                <label runat="server" id="Label1" style="font-size:18pt;display:block">Proceed To Doctor Room </label>
                            </td>
                            <#} else
                             {#> 
                              <# if(Doctor_Data[j].DocID==Doctor_Data[j-1].DocID){ #> 
                          <td style="text-align:center;"><#=objRow.TokenNo.toProperCase() #></td>
                            <#}else{ #>
                            <td style="text-align:center;" id="blink2">
                                <#=objRow.TokenNo.toProperCase() #>&nbsp; 
                                <label runat="server" id="Label2" style="font-size:18pt;display:block">Proceed To Doctor Room </label>
                                </td>
                            <#}#>
                         <%--  <td style="text-align:center;"><#=objRow.TokenNo.toProperCase() #></td>--%>
                             <#}#>
                        </tr>                       
                        <#}                        
                        #>
                              </tbody>
                        </table>
              </script>
       <%-- <script id="tb_PatientList" type="text/html">
                        <table border="0"  class="tbPatient" >
                       <tr>
                          <th style="text-align:center">Patient Name</th>
                          <th style="text-align:center">Token No.</th>                       
                        </tr>
                           <#
                             var dataLength=Patient_Data.length;
                              var loop_UpTo=0;
                              loop_UpTo=Patient_Start+No_of_Display;    
                           var objRow;   
                           for(var j=Patient_Start;j<=loop_UpTo-1;j++)
                           {        
                           if(j<dataLength)
                          {
                           objRow = Patient_Data[j];               
                            #>
                           <tr class="trPatient">
                          <td style="text-align:center; font:bold;width:50%"> <#=objRow.PName#></td>
                            <# if(j!=0){#>
                            <td style="text-align:center;"><#=objRow.TokenNo#></td>
                           <#} 
                            else
                            {#>
                            <%--<td style="text-align:center;" id="blink">
                                <#=objRow.TokenNo#>&nbsp; 
                                <label runat="server" id="lblProced" style="font-size:18pt">Proceed To Doctor Room </label>
                            </td>
                            <# }
                            #>
                        </tr>
                        <#
                        }
                        }                       
                        if(loop_UpTo>=dataLength)
                        {
                        Patient_Start=-1;
                        }
                        else
                        Patient_Start=eval(No_of_Display+Patient_Start);
                        #>
                     </table>
        </script>--%>
    </form>
</body>
</html>
