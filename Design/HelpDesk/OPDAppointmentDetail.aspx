<%@ Page  Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="OPDAppointmentDetail.aspx.cs" Inherits="Design_HelpDesk_OPDAppointmentDetail" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
                               <script type="text/javascript" src="../../Scripts/Message.js"></script>

    <script type="text/javascript" >
        $(document).ready(function () {
            $('#txtfromDate').change(function () {
                ChkDate();
            });
            $('#txtToDate').change(function () {
                ChkDate();
            });
        });
        function ChkDate() {

            $.ajax({

                url: "../Common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtfromDate').val() + '",DateTo:"' + $('#txtToDate').val() + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#lblMsg').text('To date can not be less than from date!');
                        $('#btnSearch').attr('disabled', 'disabled');
                        $("#tbAppointment table").remove();

                    }
                    else {
                        $('#lblMsg').text('');
                        $('#btnSearch').removeAttr('disabled');
                    }
                }
            });

        }

        $(document).ready(function () {
            AutoDoctor();
        });
        function AutoDoctor() {
            $(".a").hide();
            if ($("#<%=ddlDoctor.ClientID %> option:selected").val() == "All")
                $(".a").hide();
            else
                $(".a").show();
        }

        function appointmentSearch() {
            $('#lblMsg').text('');
            $.ajax({
                type: "POST",
                url: "Services/HelpDesk.asmx/appointmentSearch",
                data: '{DocID:"' + $('#ddlDoctor').val() + '",FromDate:"' + $('#txtfromDate').val() + '",ToDate:"' + $('#txtToDate').val() + '",AppNo:"' + $('#txtAppNo').val() + '",IsConform: "",VisitType:"' + $('#ddlVisitType').val() + '",Status: "' + $('#ddlStatus').val() + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: false,
                success: function (response) {
                    appointment = jQuery.parseJSON(response.d);
                    if (appointment != null) {
                        var output = $('#tb_appointment').parseTemplate(appointment);
                        $('#appointmentOutput').html(output);
                        $('#appointmentOutput').show();
                    }
                    else {
                        DisplayMsg('MM04', 'lblMsg');
                        $('#appointmentOutput').hide();
                    }
                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'lblMsg');
                    window.status = status + "\r\n" + xhr.responseText;

                }

            });
        }
  
    </script>
   
    <div id="Pbody_box_inventory" >
         <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" 
       >
    </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
           
             
                    <b>Appointment Confirmation </b><br />
               
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"   ClientIDMode="Static"/>
              
          
        </div>
        <div class="POuter_Box_Inventory" >
            <div class="Purchaseheader">
                Search Criteria</div>
            <div>
                <table>
                    <tr>
                        <td style="text-align: right; width: 499px; height: 26px;">
                            From Appointment&nbsp;Date :
                        </td>
                        <td style="text-align: left; width: 373px; height: 26px;">
                            <asp:TextBox ID="txtfromDate" runat="server" 
                                ToolTip="Click To Select From Date" Width="129px" TabIndex="1" 
                                 ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="clcAppDate" runat="server" TargetControlID="txtfromDate"
                                Format="dd-MMM-yyyy" ClearTime="true">
                            </cc1:CalendarExtender>
                        </td>
                        <td style="text-align: right; width: 265px; height: 26px;">
                            To Appointment&nbsp;Date :
                        </td>
                        <td style="text-align: left; height: 26px;">
                            <asp:TextBox ID="txtToDate" runat="server"  ToolTip="Click To Select To Date"
                                Width="129px" TabIndex="2" 
                                ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="txtCurrentDate0_CalendarExtender" runat="server" TargetControlID="txtToDate"
                                Format="dd-MMM-yyyy" ClearTime="true">
                            </cc1:CalendarExtender>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right; width: 499px;">
                            Doctor Name :
                        </td>
                        <td style="text-align: left; margin-left: 40px; width: 373px;">
                            <asp:DropDownList ID="ddlDoctor" runat="server" Width="200px" onchange="AutoDoctor();" 
                                TabIndex="3" ToolTip="Select Dotor Name" ClientIDMode="Static">
                            </asp:DropDownList>
                        </td>
                        <td style="text-align: right; display:none; width: 265px;" class="a">
                            Appointment No. :
                        </td>
                        <td style="text-align: left;display:none; " class="a">
                            <asp:TextBox ID="txtAppNo" runat="server" ClientIDMode="Static" Width="129px" MaxLength="3"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="ftbApp" runat="server" TargetControlID="txtAppNo"  FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right; width: 499px;">
                            Patient Type :</td>
                        <td style="text-align: left; margin-left: 40px; width: 373px;">
                            <asp:DropDownList ID="ddlVisitType" Width="200px" runat="server" ClientIDMode="Static">
                                <asp:ListItem>All</asp:ListItem>
                                <asp:ListItem>Old Patient</asp:ListItem>
                                <asp:ListItem>New Patient</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <td style="text-align: right; width: 265px;">
                            Status :</td>
                        <td style="text-align: left; ">
                            <asp:DropDownList ID="ddlStatus" Width="200px" runat="server" ClientIDMode="Static">
                                <asp:ListItem>All</asp:ListItem>
                                <asp:ListItem>Confirmed</asp:ListItem>
                                <asp:ListItem>ReScheduled</asp:ListItem>
                                <asp:ListItem>Pending</asp:ListItem>
                                <asp:ListItem>App Time Expired</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                   
                    <tr>
                        <td style="text-align: center; " colspan="4">
                            <input type ="button" value="Search" class="ItDoseButton" id="btnSearch"  onclick="appointmentSearch()"/>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right; width: 499px;">
                            &nbsp;
                        </td>
                        <td colspan="2" style="text-align: left">
                            <table style="width: 142%">
                                <tr>
                                    <td style="background-color: LimeGreen; width: 20px; height: 8px;">
                                    </td>
                                    <td style="width: 34px; height: 8px;">
                                        Confirmed
                                    </td>
                                    <td style="background-color:Yellow; width: 20px; height: 8px;">
                                    </td>
                                    <td style="width: 16px; height: 8px;">
                                        Rescheduled
                                    </td>
                                    <td style="background-color: LightPink; width: 20px; height: 8px; display:none">
                                    </td>
                                    <td style="width: 39px; height: 8px; display:none">
                                        Canceled</td>
                                    <td style="background-color: LightBlue; width: 20px; height: 8px;">
                                    </td>
                                    <td style="width: 53px; height: 8px;">
                                        Pending
                                    </td>
                                    <td style="background-color: Olive; width: 20px; height: 8px;">
                                    </td>
                                    <td style="width: 175px; height: 8px;"> Appointment Time Expired </td>
                                </tr>
                            </table>
                        </td>
                        <td style="text-align: left; width: 730px;">
                          </td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory" >
            <div class="Purchaseheader" >
                Results</div>

              <div id="appointmentOutput" style="max-height: 600px; overflow-x: auto;">
                        </div>
        </div>
    </div>
   <script id="tb_appointment" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" 
    style="width:950px;border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:70px;">App. No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:240px;">Patient Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:240px;">Doctor Name</th>	
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;  ">Patient Type</th>		          
            <th class="GridViewHeaderStyle" scope="col" style="width:90px; ">App. Time</th>			 
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;">App. Date</th>           
		</tr>
        <#       
        var dataLength=appointment.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        for(var j=0;j<dataLength;j++)
        {       
        objRow = appointment[j];
        #>
                  <tr id="<#=j+1#>"  style=" <#if((objRow.IsReschedule=="0") &&(objRow.IsConform=="0") &&(objRow.IsCancel=="0")){#>
                          background-color:Olive" <#}  
                        else if(objRow.IsReschedule=="1"){#>
                        background-color:Yellow"<#}
                      else if(objRow.IsConform=="1"){#>
                        background-color:LimeGreen"<#}
                        else if(objRow.IsCancel=="1"){#>
                        background-color:LightPink"<#}
                        
                        #>
                        >                           
                    <td class="GridViewLabItemStyle" style="width:10px;"><#=j+1#></td>
                    <td class="GridViewLabItemStyle"   style="width:70px;text-align:center" ><#=objRow.AppNo#></td>
                    <td class="GridViewLabItemStyle"   style="width:240px;text-align:left" ><#=objRow.NAME#></td>
                    <td class="GridViewLabItemStyle"  style="width:240px;" ><#=objRow.DoctorName#></td>
                    <td class="GridViewLabItemStyle"  style="width:90px;"><#=objRow.VisitType#></td>
                    <td class="GridViewLabItemStyle"  style="width:90px;"><#=objRow.AppTime#></td>
                    <td class="GridViewLabItemStyle" style="width:90px; text-align:right"><#=objRow.AppDate#></td>
                                             
                            
                                                                  
                                 
                    </tr>            
        <#}        
        #>      
     </table>    
    </script>
</asp:Content>

