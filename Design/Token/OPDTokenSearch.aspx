<%@ Page  Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="OPDTokenSearch.aspx.cs" Inherits="Design_Token_OPDTokenSearch" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            $('#txtFromDate').change(function () {
                ChkDate();

            });

            $('#txtToDate').change(function () {
                ChkDate();

            });

        });
        function ChkDate() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtFromDate').val() + '",DateTo:"' + $('#txtToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#lblMsg').text('To date can not be less than from date!');
                        $('#btnSearch').attr('disabled', 'disabled');
                        $('#OPDTokenOutput').hide('slow');
                        return;
                    }
                    else {
                        $('#OPDTokenOutput').show('slow');
                        searchDoctorToken();
                        $('#lblMsg').text('');
                        $('#btnSearch').removeAttr('disabled');

                    }
                }
            });

        }

    </script>
    <script type="text/javascript" >
        window.setInterval(function () {
            searchDoctorToken();
        }, 5000);
        function searchDoctorToken() {
            $("#btnSearch").prop("disabled", "disabled");
            $.ajax({
                type: "POST",
                url: "Services/token.asmx/LoadDoctorToken",
                data: '{MRNo:"' + $.trim($("#<%=txtRegNo.ClientID%>").val()) + '",PName:"' + $.trim($("#<%=txtPName.ClientID%>").val()) + '",AppNo:"' + $.trim($("#<%=txtAppNo.ClientID%>").val()) + '",DoctorID:"' + $.trim($("#<%=ddlDoctor.ClientID%>").val()) + '",status:"' + $.trim($("#<%=ddlStatus.ClientID%>").val()) + '",fromDate:"' + $.trim($("#<%=txtFromDate.ClientID%>").val()) + '",toDate:"' + $.trim($("#<%=txtToDate.ClientID%>").val()) + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: true,
                success: function (response) {
                    token = jQuery.parseJSON(response.d);
                    if (token != null) {
                        var output = $('#tb_SearchToken').parseTemplate(token);
                        $('#OPDTokenOutput').html(output);
                        $('#OPDTokenOutput').show();
                        $("#btnSearch").removeProp("disabled");
                    }
                    else {
                        $('#OPDTokenOutput').hide();
                        $("#btnSearch").removeProp("disabled");
                    }
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                    $("#btnSearch").removeProp("disabled");
                }
            });
        }
        function patientIN(rowid) {
            var PatientID = $(rowid).closest('tr').find('#tdPatientID').text();
            var App_ID = $(rowid).closest('tr').find('#tdAppID').text();
            $.ajax({
                type: "POST",
                url: "Services/token.asmx/patientStatus",
                data: '{MRNo:"' + PatientID + '",AppID:"' + App_ID + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: true,
                success: function (response) {                   
                    if (response.d == "1") {
                        $("#btnIN").prop("disabled", "disabled");
                    }
                    else {
                        $("#btnIN").removeProp("disabled");
                    }
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                    $("#btnIN").removeProp("disabled");
                }
            });
        }
        function chngcur() {
            document.body.style.cursor = '';
        }
        function tokensearch(rowid) {
            var TransactionID = $(rowid).closest('tr').find('#tdTransactionID').text();
            var LedgerTnxNo = $(rowid).closest('tr').find('#tdLedgerTnxNo').text();
            var IsDone = $(rowid).closest('tr').find('#tdIsDone').text();
            var PatientID = $(rowid).closest('tr').find('#tdPatientID').text();
            var App_ID = $(rowid).closest('tr').find('#tdAppID').text();
            window.location = "../CPOE/OPD.aspx?TID=" + TransactionID + "&LnxNo=" + LedgerTnxNo + "&IsDone=" + IsDone + "&PatientID=" + PatientID + "&App_ID=" + App_ID;
        }
        </script>
    <script type="text/javascript">
        function ReseizeIframe() {
            document.getElementById("iframePatient").style.width = "100%";
            document.getElementById("iframePatient").style.height = "100%";
            document.getElementById("iframePatient").style.display = "";
        }
        function ReseizeIframeIN(TransactionID,LedgerTnxNo,PatientID,IsDone,App_ID)
        {           
            var  PageUrl="../CPOE/CPOE.aspx?TID="+TransactionID+"&LnxNo="+LedgerTnxNo+"&IsDone="+IsDone+"&PatientID="+PatientID+"&App_ID="+App_ID;
            document.getElementById("iframePatient").src = PageUrl;
            document.getElementById("iframePatient").style.width = "100%";
            document.getElementById("iframePatient").style.height = "100%";
            document.getElementById("iframePatient").style.display = "";
            document.getElementById("Pbody_box_inventory").style.display = 'none';           
        }        
    </script>
        <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sm" runat="server" />
        <div class="POuter_Box_Inventory">
            <div style="text-align: center;">
                <b>Search Patient</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" /></div>
        </div>
        <div class="POuter_Box_Inventory">
            <table style="width: 100%" cellpadding="0" cellspacing="0">
                <tr>
                    <td style="text-align: right">
                        UHID :&nbsp;
                    </td>
                    <td>
                        <asp:TextBox ID="txtRegNo" runat="server" Width="140px" TabIndex="1" ToolTip="Enter UHID" />
                        
                    </td>
                    <td style="text-align: right">
                        Patient Name :&nbsp;
                    </td>
                    <td>
                        <asp:TextBox ID="txtPName" runat="server" Width="140px" TabIndex="2" ToolTip="Enter Patient Name"  />
                    </td>
                    <td>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right">
                        App. No. :&nbsp;
                    </td>
                    <td>
                        <asp:TextBox ID="txtAppNo" runat="server" Width="140px" TabIndex="3" ToolTip="Enter  App. No." />
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" TargetControlID="txtAppNo"
                            ValidChars="0987654321">
                        </cc1:FilteredTextBoxExtender>
                    </td>
                    <td style="text-align: right">
                        Doctor Name :&nbsp;
                    </td>
                    <td>
                      <asp:DropDownList ID="ddlDoctor" runat="server" Width="146px" TabIndex="4" ToolTip="Select  Doctor Name"/>

                    </td>
                    <td>
                        &nbsp;
                    </td>
                </tr>
               
                <tr>
                    <td style="text-align: right">
                      Status :&nbsp;  
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlStatus" runat="server" Width="146px" TabIndex="5">
                            <asp:ListItem Selected="True" Text="Pending" Value="1"></asp:ListItem>
                            <asp:ListItem  Text="IN" Value="2"></asp:ListItem>
                            <asp:ListItem  Text="Out" Value="3"></asp:ListItem>
                            <asp:ListItem  Text="All" Value="4"></asp:ListItem>
                        </asp:DropDownList>
                    </td>
                    <td style="text-align: right">
                    </td>
                    <td>
                    </td>
                    <td>
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right">
                        From Appointment Date :&nbsp;
                    </td>
                    <td>
                        <asp:TextBox ID="txtFromDate" runat="server" ToolTip="Select  Date" Width="140px" TabIndex="8"
                            ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="clcAppDate" runat="server"  TargetControlID="txtFromDate" Format="dd-MMM-yyyy"
                            ClearTime="true">
                        </cc1:CalendarExtender>
                    </td>
                    <td style="text-align: right">
                         To Appointment Date :&nbsp;
                    </td>
                    <td>
                         <asp:TextBox ID="txtToDate" runat="server" ToolTip="Select To Date" ClientIDMode="Static"
                            Width="140px" TabIndex="9"></asp:TextBox>
                        <cc1:CalendarExtender ID="txtAppointmentDate0_CalendarExtender" runat="server" TargetControlID="txtToDate"
                            Format="dd-MMM-yyyy" ClearTime="true">
                        </cc1:CalendarExtender>
                    </td>
                    <td>
                        &nbsp;
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory">
            <div style="text-align: center;"> 
                <input type="button" value="Search" id="btnSearch" onclick="searchDoctorToken()" class="ItDoseButton" />
            </div>
        </div>
        <div class="POuter_Box_Inventory">
        <table cellpadding="0" cellspacing="0" style="width: 100%" id="myTable">
                <tr >
                    <td colspan="4">
                         <div id="OPDTokenOutput" style="max-height: 600px; overflow-x: auto;">
                        </div>
                        <br />                       
                    </td>
                </tr>
            </table>
    </div>
    </div>
     <iframe id="iframePatient" name="iframePatient" src="" style="position: fixed; top: 0px;
        left: 0px; background-color: #FFFFFF; display: none;" frameborder="0" enableviewstate="true">
    </iframe>
        <script id="tb_SearchToken" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdOPDFinalSettlement"
    style="width:960px;border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">App. No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;">UHID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:160px;">Patient Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:60px;">Status</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Token Date</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Token No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px; display:none ">AppID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px; display:none ">LedgertransactionNo</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;display:none">TransactionID</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:60px;display:none">IsDone</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:30px;"></th>
            <th class="GridViewHeaderStyle" scope="col" style="width:30px;"></th>           
		</tr>
        <#       
        var dataLength=token.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;
        for(var j=0;j<dataLength;j++)
        {       
        objRow = token[j];
        #>
                    <tr id="<#=j+1#>">                            
                    <td class="GridViewLabItemStyle" style="width:10px;"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="tdAppNo"  style="width:50px;text-align:center" ><#=objRow.AppNo#></td>
                    <td class="GridViewLabItemStyle" id="tdPatientID"  style="width:90px;" ><#=objRow.PatientID#></td>
                    <td class="GridViewLabItemStyle" id="tdPatientName" style="width:160px;"><#=objRow.Pname#></td>
                    <td class="GridViewLabItemStyle" id="tdStatus" style="width:60px;"><#=objRow.Status#></td>
                    <td class="GridViewLabItemStyle" id="tdTockenCreatedDate" style="width:50px;"><#=objRow.TockenCreatedDate#></td>
                    <td class="GridViewLabItemStyle" id="tdtokenNo" style="width:60px; text-align:center;font-size:medium;font:bold;color: green"><#=objRow.tokenNo#></td>
                    <td class="GridViewLabItemStyle" id="tdAppID" style="width:60px;display:none"><#=objRow.App_ID#></td>                     
                    <td class="GridViewLabItemStyle" id="tdLedgerTnxNo" style="width:60px;display:none"><#=objRow.LedgerTnxNo#></td>
                    <td class="GridViewLabItemStyle" id="tdTransactionID"  style="width:60px;display:none" ><#=objRow.TransactionID#></td>                                                           
                    <td class="GridViewLabItemStyle" id="tdIsDone"  style="width:60px;display:none" ><#=objRow.IsDone#></td>   
                    <td class="GridViewLabItemStyle" style="width:30px; text-align:center"  >
                    <a target="iframePatient" href="javascript:void(0);"
                          <#if(objRow.P_IN=="0" && objRow.CurrentDateCon=="1"){#>
             onclick="ReseizeIframeIN('<#=objRow.TransactionID#>','<#=objRow.LedgerTnxNo#>','<#=objRow.PatientID#>','<#=objRow.IsDone#>','<#=objRow.App_ID#>');" >
<#}#>
                      <input type="button" id="btnIN" value="IN"  class="ItDoseButton" onclick="patientIN(this)"
                         <#if(objRow.P_IN=="1" || objRow.CurrentDateCon=="0"){#>
                          disabled="disabled"<#}#> 
                          /></a>
                  </td>
                     <td class="GridViewLabItemStyle" style="width:30px; text-align:center"  >
                     <a target="iframePatient" href="OPD.aspx?TID=<#=objRow.TransactionID#>&amp;LnxNo=<#=objRow.LedgerTnxNo#>&amp;IsDone=<#=objRow.IsDone#>&amp;PatientID=<#=objRow.PatientID#>&amp;App_ID=<#=objRow.App_ID#>"
                     <#if(objRow.P_IN=="1"){#>
                          onclick="ReseizeIframe();"<#}#> >                          
                     <img alt="Select" src="../../Images/Post.gif" style="border: 0px solid #FFFFFF;  
                          <#if(objRow.Status=="Pending"){#>    
                         display:none
                         <#}#>                  
                         "/></a>                                                                                
                    </td>                    
                    </tr>           
        <#}       
        #>       
     </table>    
    </script>

</asp:Content>

