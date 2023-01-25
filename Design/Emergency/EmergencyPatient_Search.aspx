<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="EmergencyPatient_Search.aspx.cs" Inherits="Design_Emergency_EmergencyPatient_Search" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <style type="text/css">
        .hover {
            background-color: LightBlue;
            color: white;
            cursor: default;
        }

        .Counthover {
            background-color: LightBlue;
            color: white;
            cursor: pointer;
        }
       
    </style>
    <script type="text/javascript">
        function ReseizeIframe() {
            document.getElementById("iframePatient").style.width = "100%";
            document.getElementById("iframePatient").style.height = "100%";
            document.getElementById("iframePatient").style.display = "";
        }
        function PatientOutstanding(PatientID) {
            var con = 0;
            $.ajax({
                url: "../Common/CommonService.asmx/PatientOutstanding",
                data: '{PatientID:"' + PatientID + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    if (mydata.d != "") {
                        var Ok = confirm('Patient Previous Balance Amount : ' + mydata.d);
                        if (Ok)
                            con = 0;
                        else {
                            con = 1;
                        }
                    }
                    if (con == 0)
                    {
                        ReseizeIframe();
                    }
                }

            });

        }
        
    </script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sm" runat="server" />
        <div class="POuter_Box_Inventory">
            <div style="text-align: center;">
                <b>Search Emergency Patient</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />

            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <table style="width: 100%;border-collapse:collapse">
                <tr>
                    <td style="text-align: right;width:14%">UHID :&nbsp;</td>
                    <td style="text-align:left;width:32%">
                        <asp:TextBox ID="txtRegNo" runat="server" Width="150px" ClientIDMode="Static" TabIndex="1" ToolTip="Enter UHID" />

                    </td>
                    <td style="text-align: right;width:14%">Patient Name :&nbsp;</td>
                    <td style="text-align:left;width:40%">
                        <asp:TextBox ID="txtPName" ClientIDMode="Static" runat="server" Width="150px" TabIndex="2" ToolTip="Enter Patient Name" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right;width:14%">From Date :&nbsp;</td>
                   <td style="text-align:left;width:32%">
                        <asp:TextBox ID="fromDate"  runat="server" ToolTip="Select From Date" Width="150px" TabIndex="8"
                            ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="fromDate" Format="dd-MMM-yyyy"
                            ClearTime="true">
                        </cc1:CalendarExtender>
                    </td>
                    <td style="text-align: right;width:14%">To Date :&nbsp;</td>
                    <td style="text-align:left;width:40%">
                        <asp:TextBox ID="toDate" runat="server" ToolTip="Select To Date" ClientIDMode="Static"
                            Width="150px" TabIndex="9"></asp:TextBox>
                        <cc1:CalendarExtender ID="calTodate" runat="server" TargetControlID="toDate"
                            Format="dd-MMM-yyyy" ClearTime="true">
                        </cc1:CalendarExtender>
                    </td>
                </tr>
               
                <tr>
                    <td style="text-align: right;width:14%">
                         &nbsp;
                    </td>
                     <td  style="text-align: center">
                         <asp:RadioButtonList ID="rdbType" runat="server" RepeatDirection="Horizontal" ClientIDMode="Static"  >
                        <asp:ListItem Value="0" Selected="True">Admitted Patient</asp:ListItem>
                        <asp:ListItem Value="1">Discharged Patient</asp:ListItem>
                        </asp:RadioButtonList></td>
                     <td style="text-align: right">Doctor Name :&nbsp;
                    </td>
                    <td>                        
                        <asp:DropDownList ID="ddlDoctor" runat="server" Width="156px" TabIndex="4" ToolTip="Select  Doctor Name" ClientIDMode="Static" />
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align:center">
            <input type="button" value="Search" tabindex="10" id="btnSearch" onclick="searchEmergency()" class="ItDoseButton" />
            </div> 
            
        <div class="POuter_Box_Inventory" id="emergency" style="text-align:center;display:none">
            <div class="Purchaseheader">
                Search Result
            </div>
        <table  style="width: 100%;border-collapse:collapse" >
                <tr >
                    <td colspan="4">
                         <div id="EmergencyOutput" style="max-height: 400px; overflow-x: auto;">
                        </div>
                        <br />                       
                    </td>
                </tr>
            </table>
    </div>
    </div>
    <iframe id="iframePatient" name="iframePatient" src="" style="position: fixed; top: 0px; left: 0px; background-color: #FFFFFF; display: none;"
        frameborder="0" enableviewstate="true"></iframe>

    <script type="text/javascript">
        function searchEmergency() {
            $("#lblMsg").text('');
            $("#btnSearch").attr("disabled", true).val("Searching...");
            $.ajax({
                type: "POST",
                url: "EmergencyPatient_Search.aspx/bindEmerDetail",
                data: '{fromDate:"' + $.trim($("#<%=fromDate.ClientID%>").val()) + '",toDate:"' + $.trim($("#<%=toDate.ClientID%>").val()) + '",PatientID:"' + $.trim($("#<%=txtRegNo.ClientID%>").val()) + '",PName:"' + $.trim($("#<%=txtPName.ClientID%>").val()) + '",status:"' + $("#rdbType input[type=radio]:checked").val() + '",Doctor:"'+ $('#ddlDoctor').val() +'"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: true,
                success: function (response) {
                    emer = jQuery.parseJSON(response.d);
                    if (emer != null) {
                        var output = $('#tb_SearchEmergency').parseTemplate(emer);
                        $('#EmergencyOutput').html(output);
                        $('#EmergencyOutput,#emergency').show();
                        $('#tb_grdEmergency tr').bind('mouseenter mouseleave', function () {
                            $(this).toggleClass('Counthover');
                        });
                    }
                    else {
                        $('#EmergencyOutput,#emergency').hide();
                        $("#lblMsg").text('No Record Found');
                    }
                    $("#btnSearch").val('Search').removeAttr("disabled");
                },
                error: function (xhr, status) {
                    $("#btnSearch").val('Search').removeAttr("disabled");
                }
            });
        }
    </script>
     <script id="tb_SearchEmergency" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdEmergency"
    style="width:950px;border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>          
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;">UHID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:160px;">Patient Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Age</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Sex</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Date</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:160px;">Doctor</th>         
            <th class="GridViewHeaderStyle" scope="col" style="width:60px; display:none ">AppID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px; display:none ">DoctorID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:30px;"></th>
                   
		</tr>
        <#       
        var dataLength=emer.length;
        var objRow;   
        var status;
        for(var j=0;j<dataLength;j++)
        {       
        objRow = emer[j];
        #>
          
                    <tr id="<#=j+1#>">      
                    <td class="GridViewLabItemStyle" style="width:10px;"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="tdPatientID"  style="width:90px;" ><#=objRow.PatientID#></td>
                    <td class="GridViewLabItemStyle" id="tdPatientName" style="width:160px;"><#=objRow.PName#></td>
                    <td class="GridViewLabItemStyle" id="tdAge" style="width:60px;"><#=objRow.Age#></td>
                    <td class="GridViewLabItemStyle" id="tdSex" style="width:60px;"><#=objRow.Sex#></td>
                    <td class="GridViewLabItemStyle" id="tdAppDate" style="width:80px;text-align:center"><#=objRow.AppDate#></td>
                    <td class="GridViewLabItemStyle" id="tdDName" style="width:160px;"><#=objRow.DName#></td>                   
                    <td class="GridViewLabItemStyle" id="tdAppID" style="width:60px;display:none"><#=objRow.App_ID#></td>                     
                    <td class="GridViewLabItemStyle" id="tdDoctorID" style="width:60px;display:none"><#=objRow.DoctorID#></td>
                    
                     <td class="GridViewLabItemStyle" style="width:30px; text-align:center" id="tdSelect"  >
                         <# if(objRow.IsView =="1"){#>   
                     <a target="iframePatient" id="ifselect" onclick="PatientOutstanding('<#=objRow.PatientID#>');" href="Emergency.aspx?PID=<#=objRow.PatientID#>&amp;App_ID=<#=objRow.App_ID#>&amp;TID=<#=objRow.TransactionID#>&amp;Date=<#=objRow.AppDate#>&amp;LnxNo=<#=objRow.LedgerTnxNo#>">
                       <img alt="Select" src="../../Images/Post.gif" style="border: 0px solid #FFFFFF;" /></a>    
                                  <#}#>                                                                  
                    </td>     
                    </tr>           
        <#}       
        #>       
     </table>    
    </script>
   
</asp:Content>

