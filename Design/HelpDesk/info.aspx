<%@ Page Language="C#" AutoEventWireup="true" MaintainScrollPositionOnPostback="true" CodeFile="info.aspx.cs" MasterPageFile="~/DefaultHome.master" Inherits="Design_HelpDesk_info" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="asp" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:content id="content3" contentplaceholderid="ContentPlaceHolder1" runat="server">
    <script type="text/javascript" src="../../Scripts/jquery.extensions.js"></script>
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <style type="text/css">
        .blue {
        background-color:blue;
        color:white;
        }
    </style>
    <script type="text/javascript">
        var TicketId = "";
        $(document).ready(function () {
            TicketId = '<%=Util.GetString(Request.QueryString["TicketId"].ToString())%>';
            bindTicketDetail();
            bindTicketInfo();
            replyBind();
            CloseStatus();
            bindTicketInfoReply();
            bindToAssignedTo();
            if (localStorage.getItem("x") == "0") {

                localStorage.setItem("x", "1");
                window.location.reload();

            }
            if (localStorage.getItem("isdup") == "0") {

                localStorage.setItem("isdup", "1");
                //alert("Duplicate entry not possible");

            }

            
        });

        function updatePriority() {
            $("#lblErrormsg").text('');
            if ($("#ddlPriority").val() != "0") {

                if ($("#<%=ddlStatus.ClientID%>").val() != "4") {
                    if ($("#tb_grdticket tr").length == 0) {
                        $("#lblErrormsg").text("Please Add Atleast One Reply Before Closing Ticket");
                        return;
                    }

                    if ($("#<%=ddlStatus.ClientID%>").val() == "5") {
                        if ($("#ddlForwordToDepartment").val() == "" || $("#ddlForwordToDepartment").val() == "0" || $("#ddlForwordToDepartment").val() == undefined) {
                            $("#lblErrormsg").text("Please Select forword to department.");
                            return;
                        }

                    }
                }
                else if ($("#<%=ddlStatus.ClientID%>").val() == "4") {

                    if ($("#ddlEmployee").val() == "" || $("#ddlEmployee").val() == "0" || $("#ddlEmployee").val() == undefined) {
                        $("#lblErrormsg").text("Please Select Assigned to Employee.");
                        return;
                    }

                }
                if ($("#<%=ddlSection.ClientID%>").val() == "Select") {

                    if ($("#<%=ddlSection.ClientID%>").val() == "" || $("#<%=ddlSection.ClientID%>").val() == "0" || $("#<%=ddlSection.ClientID%>").val() == undefined || $("#<%=ddlSection.ClientID%>").val() == "Select") {
                        $("#lblErrormsg").text("Please Select Section of Employee.");
                        return;
                    }

                }

                $.ajax({
                    type: "POST",
                    url: "Services/HelpDesk.asmx/updatePriority",
                    data: '{statusID:"' + $("#<%=ddlStatus.ClientID%>").val() + '",Priority:"' + $("#ddlPriority option:selected").text() + '",PriorityID:"' + $("#ddlPriority").val() + '",TicketId:"' + TicketId + '",Decription:"' + $("#txtDecription").val() + '",CloseDate:"' + $("#txtCloseDate").val() + '", CloseTime:"' + $("#txtCloseTime").val() + '",status:"' + $("#<%=ddlStatus.ClientID%> option:selected").text() + '",AssignedEngineer:"' + $("#ddlEmployee option:selected").text() + '", AssignedEngineerID:"' + $("#ddlEmployee").val() + '",ForwordToDepartment:"' + $("#ddlForwordToDepartment").val() + '",Section:"' + $("#<%=ddlSection.ClientID%>").val() + '",IsSubTicket:"'+$("#spanIsSubTicket").text()+'"}',
                    dataType: "json",
                    contentType: "application/json;charset=UTF-8",
                    async: false,
                    success: function (response) {
                        ticket = response.d;
                        if (ticket == "1") {

                            $("#spanIsSubTicket").text("0");

                            $('#<%=ddlSection.ClientID %>').prop('disabled', true);
                            DisplayMsg('MM01', 'lblErrormsg');
                            var status = $("#<%=ddlStatus.ClientID%>").val()
                            if (status == 2) {
                                window.location.reload();
                                //$("#btnReply").attr("disabled", "disabled");
                                // $("#btnUpdate").attr("disabled", "disabled");
                                //  $("#<%=ddlStatus.ClientID%>").attr("disabled", "disabled");
                                //  $("#ddlPriority").attr("disabled", "disabled");
                            }
                            bindTicketInfo();
                            bindTicketInfoReply();
                        }
                        else {
                            if (ticket == "7") {
                                $('#lblErrormsg').text("Section Already Added");

                            }
                            else {
                                if (ticket == "3") {
                                    
                                        $('#lblErrormsg').text("More than one Parent not possible");
                                    
                                }
                                else {
                                    
                                    if (ticket == "13" || ticket == "5") {
                                        //alert("Duplicate Assign not possible");

                                    }
                                    else {
                                        DisplayMsg('MM05', 'lblErrormsg');
                                    }
                                }
                            }
                        }

                        localStorage.setItem("x", "0");
                        window.location.reload();
                    },
                    error: function (xhr, status) {
                        DisplayMsg('MM05', 'lblErrormsg');
                        window.status = status + "\r\n" + xhr.responseText;
                    }
                });
            }
            else {
                $("#lblErrormsg").text('Please Select Priority');
                $("#ddlPriority").focus();
            }
        }

        function updateTicket_Master() {
            $("#lblErrormsg").text('');
            if ($("#txtCostCentre").val() == "") {
                $("#lblErrormsg").text('Enter Cost Centre.');
                $("#txtCostCentre").focus();
                        return;
            }
            if ($("#ddlProjectSupervisor").val() == "0") {
                $("#lblErrormsg").text('Select Project Supervisor.');
                $("#ddlProjectSupervisor").focus();
                return;
            }

                 
                $.ajax({
                    type: "POST",
                    url: "Services/HelpDesk.asmx/updateTicket_Master",
                    data: '{TicketId:"' + TicketId + '",CostCentre:"' + $("#txtCostCentre").val() + '",ProjectSupervisor:"' + $("#ddlProjectSupervisor").val() + '"}',
                    dataType: "json",
                    contentType: "application/json;charset=UTF-8",
                    async: false,
                    success: function (response) {
                        ticket = response.d;
                        if (ticket == "1") {

                            $("#lblErrormsg").text('Successfully saved.');
                        }
                        else {
                            DisplayMsg('MM05', 'lblErrormsg');
                        }
                    },
                    error: function (xhr, status) {
                        DisplayMsg('MM05', 'lblErrormsg');
                        window.status = status + "\r\n" + xhr.responseText;
                    }
                });
            
        }



        function replyTicket() {
            if ($("#txtDecription").val() != "") {
                $.ajax({
                    type: "POST",
                    url: "Services/HelpDesk.asmx/ReplyTicket",
                    data: '{status:"' + $("#<%=ddlStatus.ClientID%> option:selected").text() + '",Description:"' + $("#txtDecription").val() + '",TicketId:"' + TicketId + '"}',
                    dataType: "json",
                    contentType: "application/json;charset=UTF-8",
                    async: false,
                    success: function (response) {
                        ticket = response.d;
                        if (ticket == "1") {
                            DisplayMsg('MM01', 'lblErrormsg');
                            $("#txtDecription").val('')
                            //$("#btnReply").attr("disabled", "disabled");
                            //$("#btnUpdate").attr("disabled", "disabled");
                        }
                        else {
                            DisplayMsg('MM05', 'lblErrormsg');
                        }
                        replyBind();
                    },
                    error: function (xhr, status) {
                        DisplayMsg('MM05', 'lblErrormsg');
                        window.status = status + "\r\n" + xhr.responseText;
                    }
                });
            }
            else {
                $("#lblErrormsg").text('Please Enter Description');
                $("#txtDecription").focus();
            }
        }

        function replyBind() {
            $.ajax({
                type: "POST",
                url: "Services/HelpDesk.asmx/reply_bind",
                data: '{TicketID:"' + TicketId + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: false,
                success: function (response) {
                    ticket = jQuery.parseJSON(response.d);
                    if (ticket != null) {
                        var output = $('#tb_ticket').parseTemplate(ticket);
                        $('#ticketReplyOutput').html(output);
                        $('#ticketReplyOutput').show();
                    }
                    else {
                        $('#ticketReplyOutput').hide();
                    }
                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'lblErrormsg');
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }

        function bindTicketDetail() {
            $.ajax({
                type: "POST",
                url: "Services/HelpDesk.asmx/bindTicketDetail",
                data: '{TicketNo:"' + TicketId + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: false,
                success: function (response) {
                    Detail = jQuery.parseJSON(response.d);
                    if (Detail != null) {
                        $("#lblTicketID").text(Detail[0].TicketNo);
                        $("#lblStatus1").text(Detail[0].STATUS);
                        $("#lblName").text(Detail[0].NAME);
                        $("#lblDept").text(Detail[0].Department);
                        $("#lblLocation").text(Detail[0].Location);
                        $("#lblLocationCode").text(Detail[0].LocationCode);
                        $("#lblRequestedBy").text(Detail[0].RequestedBy);
                        $("#txtCostCentre").val(Detail[0].CostCentre);
                        bindToEmployeeP();
                        // $("#ddlProjectSupervisor").val(Detail[0].ProjectSupervisor).chosen("destroy").chosen();;
                        $("#ddlProjectSupervisor").val(Detail[0].ProjectSupervisor);
                        //alert(Detail[0].ProjectSupervisor);
                        $("#lblPriority").text(Detail[0].Priority);
                        $("#lblFloor").text(Detail[0].FLOOR);
                        $("#lblProblemStartTime").text(Detail[0].ProblemStartTime);
                        $("#lblDate").text(Detail[0].DATE);
                        $("#lblErrorType").text(Detail[0].ErrorType);
                        $("#<%=ddlStatus.ClientID%>").val(Detail[0].StatusID);
                        $("#lblDescription").text(Detail[0].Description);
                        $("#ddlPriority").val(Detail[0].PriorityID);
                        if (Detail[0].IsVisit == 0)
                            $("#<%=lblResponse.ClientID%>").text('First Visit Remarks');
                        if (Detail[0].Attachment != "") {
                            $("#lnkbtnAttachment").show();
                            var path = Detail[0].Attachment;
                            $("#<%=lblAttachment.ClientID%>").text(Detail[0].Attachment_Name);
                            $("#<%=txtAttachment.ClientID%>").val(path + "#" + Detail[0].Attachment_Name);

                        }

                        if (Detail[0].STATUS == "Close") {
                            
                            $("#btnItemlist").attr("disabled", "disabled");
                            $("#btnItemlist").hide();
                            $("#btnReply").attr("disabled", "disabled");
                            $(".subticketbutton").attr("disabled", "disabled");
                            $("#btnUpdate").attr("disabled", "disabled");
                            $("#ddlReplyRspnce").attr("disabled", "disabled");
                            $("#btnUpdate").hide();
                            $("#btnReOpen,#trReopen").show();
                            $("#<%=ddlStatus.ClientID%>").val(Detail[0].StatusID).attr('disabled', 'disabled');
                            $("#txtReopenReason").val('');

                            $(".divAssigned").hide();
                            $(".divForword").hide();
                            $(".divClose").hide();
                        }
                        else {
                            
                            $("#btnUpdate").show();
                            $("#btnReOpen,#trReopen").hide();
                            $("#txtReopenReason").val(''); 
                            CloseStatus();
                        }
                        if (Detail[0].STATUS == "Close") {
                            bindEmpTicketDetail(Detail[0].CloseBy, Detail[0].CloseDate);
                        }
                    }
                    else {
                        DisplayMsg('MM05', 'lblErrormsg');
                    }
                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'lblErrormsg');
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }

        function bindEmpTicketDetail(CloseBy, CloseDate) {
            $.ajax({
                type: "POST",
                url: "Services/HelpDesk.asmx/bindEmpTicketDetail",
                data: '{CloseBy:"' + CloseBy + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: false,
                success: function (response) {
                    name = response.d;
                    if (name != "") {
                        $("#lblClose").text(name);
                        $("#lblDateTime").text(CloseDate);
                        $("#lbl1").show();
                        $("#lblClosedDate").show();
                    }
                    else {

                    }
                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'lblErrormsg');
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }

        function bindResponse() {
            $.ajax({
                type: "POST",
                url: "Services/HelpDesk.asmx/bindResponse",
                data: '{Reply:"' + $("#ddlReplyRspnce").val() + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: false,
                success: function (response) {
                    desc = response.d;
                    if (desc != "") {
                        $("#txtDecription").val(desc);
                    }
                    else {
                        $("#txtDecription").val('');
                    }
                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'lblErrormsg');
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }



        function bindPriority() {
            $('#lblErrormsg').text('');
            var Priority = $("#ddlPriority");
            $("#ddlPriority option").remove();
            $.ajax({
                url: "Services/HelpDesk.asmx/bindPriority",
                data: '{}', // parameter map
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    Data = jQuery.parseJSON(result.d);
                    if (Data.length == 0) {
                        Priority.append($("<option></option>").val("0").html("---No Data Found---"));
                    }
                    else {
                        for (i = 0; i < Data.length; i++) {
                            Priority.append($("<option></option>").val(Data[i].ID).html(Data[i].Name));
                        }
                    }
                    Priority.attr("disabled", false);
                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'lblErrormsg');
                    Priority.attr("disabled", false);
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
    </script>

    <script type="text/javascript">
        function CloseStatus() {
            var ddlStatus = document.getElementById('<%=ddlStatus.ClientID%>');
            var Status = ddlStatus.options[ddlStatus.selectedIndex].value;
            HideShowOnStatus(Status)
        }
    </script>

    <div id="Pbody_box_inventory">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
        
            <b>Ticket Status </b>
            <br />
            <asp:Label ID="lblErrormsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:Label>
            <div style="float: right; FONT-WEIGHT: bold; display: none">
                <asp:LinkButton ID="lbtnhome" runat="server" Text="Back" ForeColor="Red" OnClick="lbtnhome_Click">Back</asp:LinkButton>
               <span id="lblisVisited" style="display:none">0</span>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                  <a style="float: left;font-weight: bold;color:white" href="<%=Request.QueryString["BackUrl"].ToString() %>?Search=1">Back To Search Ticket</a>&nbsp;
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Ticket No.</label><b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:Label ID="lblTicketID" runat="server" ClientIDMode="Static" CssClass="ItDoseLabelSp"></asp:Label>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Status</label><b class="pull-right">:</b>
                    </div>
                        <div class="col-md-5"><asp:Label ID="lblStatus1" runat="server" ClientIDMode="Static" CssClass="ItDoseLabelSp"></asp:Label></div>
                        <div class="col-md-3"><label class="pull-left">Name</label><b class="pull-right">:</b></div>
                        <div class="col-md-5"><asp:Label ID="lblName" runat="server" ClientIDMode="Static" CssClass="ItDoseLabelSp"></asp:Label></div>
                        </div>
                    <div class="row">
                        <div class="col-md-3"><label class="pull-left">Department</label><b class="pull-right">:</b></div>
                        <div class="col-md-5">
                            <asp:Label ID="lblDept" runat="server" ClientIDMode="Static" CssClass="ItDoseLabelSp"></asp:Label></div>
                         <div class="col-md-3"><label class="pull-left">Priority</label><b class="pull-right">:</b> </div>
                        <div class="col-md-5">
                             <asp:Label ID="lblPriority" runat="server" ClientIDMode="Static" CssClass="ItDoseLabelSp"></asp:Label></div>
                        <div class="col-md-3" style="display:none;"><label class="pull-left">Floor</label><b class="pull-right">:</b> </div>
                        <div class="col-md-5" style="display:none;"> <asp:Label ID="lblFloor" runat="server" ClientIDMode="Static" CssClass="ItDoseLabelSp"></asp:Label></div>
  </div>
                                <div class="row">
                        <div class="col-md-3"><label class="pull-left">Location</label><b class="pull-right">:</b></div>
                        <div class="col-md-5">
                            <asp:Label ID="lblLocation" runat="server" ClientIDMode="Static" CssClass="ItDoseLabelSp"></asp:Label></div>
                         <div class="col-md-3"><label class="pull-left">Location Code</label><b class="pull-right">:</b> </div>
                        <div class="col-md-5">
                             <asp:Label ID="lblLocationCode" runat="server" ClientIDMode="Static" CssClass="ItDoseLabelSp"></asp:Label></div>
                        <div class="col-md-3"><label class="pull-left">Requested By</label><b class="pull-right">:</b></div>
                        <div class="col-md-5"> <asp:Label ID="lblRequestedBy" runat="server" ClientIDMode="Static" CssClass="ItDoseLabelSp"></asp:Label></div>
  </div>
                    <div class="row">
                        <div class="col-md-3"><label class="pull-left">Problem Start On</label><b class="pull-right">:</b> </div>
                        <div class="col-md-5">  <asp:Label ID="lblProblemStartTime" runat="server" ClientIDMode="Static" CssClass="ItDoseLabelSp"></asp:Label></div>
                        <div class="col-md-3"><label class="pull-left">Reporting Date</label><b class="pull-right">:</b></div><div class="col-md-5">
                             <asp:Label ID="lblClosed" runat="server" Style="display: none" Width="56px" ClientIDMode="Static" CssClass="ItDoseLabelSp"></asp:Label>
                            <asp:Label ID="lblDate" runat="server" ClientIDMode="Static" CssClass="ItDoseLabelSp"></asp:Label></div>
                         <div class="col-md-3"><label class="pull-left">Issue Type</label><b class="pull-right">:</b> </div><div class="col-md-5">
                        <asp:Label ID="lblErrorType" runat="server" ClientIDMode="Static" CssClass="ItDoseLabelSp"></asp:Label></div>
                    </div>
                    <div class="row">
                        
                        
                        <div class="col-md-3" ><label class="pull-left">Attachment</label><b class="pull-right">:</b> </div>
                        <div class="col-md-5" > <asp:Label   ID="lblAttachment" runat="server" ></asp:Label>
                        <asp:LinkButton ID="lnkbtnAttachment" ClientIDMode="Static" runat="server" Text="open" OnClick="lnkbtnAttachment_Click" style="display:none" ></asp:LinkButton>
                        <asp:TextBox style="display: none" runat="server" ID="txtAttachment"></asp:TextBox></div>
                        
                    </div>
                    <div class="row">
                        <div class="col-md-3"><label class="pull-left">Description</label><b class="pull-right">:</b></div>
                        <div class="col-md-21"><asp:Label ID="lblDescription" ClientIDMode="Static" runat="server" Font-Size="Small" CssClass="ItDoseLabelSp"></asp:Label></div>
                     </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Close Date</label><b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5"><div id="StatusClose" style="display: none">
                            <asp:TextBox ID="txtCloseDate" runat="server" Width="90px" ClientIDMode="Static" ToolTip="Click To Select Date"></asp:TextBox>
                            <cc1:CalendarExtender ID="calClose" runat="server" TargetControlID="txtCloseDate" Format="dd-MM-yyyy"></cc1:CalendarExtender>
                            <asp:TextBox ID="txtCloseTime" runat="server" Width="80px" ClientIDMode="Static" ToolTip="Enter Close Time"></asp:TextBox>
                            <cc1:MaskedEditExtender ID="mee_txtFromTime" runat="server" AcceptAMPM="true" AcceptNegative="None" Mask="99:99" MaskType="Time" TargetControlID="txtCloseTime"></cc1:MaskedEditExtender>
                        </div></div>
                        <div class="col-md-3">
                            <label class="pull-left">ReOpen Reason</label><b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <div id="trReopen" style="display:none">
                                        <asp:TextBox runat="server" MaxLength="100" Width="126px" ClientIDMode="Static" ID="txtReopenReason" ToolTip="Enter ReOpen Reason" CssClass="requiredField"></asp:TextBox>
                            </div>
                        </div>
                         <div class="col-md-3">
                            <label class="pull-left">Priority</label><b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                            <asp:DropDownList ID="ddlPriority" runat="server" Width="96px" ClientIDMode="Static" ToolTip="Select Priority"></asp:DropDownList>
                        </div>
                         <div class="col-md-2">
                             <span id="spanIsSubTicket" style="display:none;" >0</span>
                             <input type="button" id="btnShowSection" value="Add SubTicket" class="ItDoseButton"  title="" onclick="enableSection();"/>
                        
                        </div>
                       
                       </div>
                    
                    <div class="row">
                       
                        <div class="col-md-3">
                            <label class="pull-left">Cost Centre</label><b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                                        <asp:TextBox runat="server" ClientIDMode="Static" ID="txtCostCentre" ToolTip="Enter Cost Centre" ></asp:TextBox>
                            
                        </div>
                        <div class="col-md-3"><label class="pull-left">Project Supervisor</label><b class="pull-right">:</b> </div>
                        <div class="col-md-6">   
                            <asp:DropDownList ID="ddlProjectSupervisor" runat="server" Width="290px" ToolTip="Select Status" ClientIDMode="Static" >
                            </asp:DropDownList>

                        </div>
                        
                         <div class="col-md-1" style="margin-left:10px;">
                             <input type="button" id="Button2" value="Save" class="ItDoseButton"   title="" onclick="updateTicket_Master();" />
                        
                        </div>
                        </div>
                        
                    <div class="row">
                       
                        <div class="col-md-3"><label class="pull-left">Status</label><b class="pull-right">:</b> </div>
                        <div class="col-md-3">   
                            <asp:DropDownList ID="ddlStatus" runat="server" Width="96px" ToolTip="Select Status" ClientIDMode="Static" >
                            <asp:ListItem Value="0">Pending</asp:ListItem>
                                 <asp:ListItem Value="4">Assigned</asp:ListItem>
                            <asp:ListItem Value="1">Process</asp:ListItem>
                            <asp:ListItem Value="3">Reslove</asp:ListItem>
                            <asp:ListItem Value="2">Close</asp:ListItem> 
                             <asp:ListItem Value="5">Forward</asp:ListItem>
                        </asp:DropDownList>

                        </div>

                         <div class="col-md-3 divAssigned"><label class="pull-left">Section</label><b class="pull-right">:</b> </div>
                        <div class="col-md-3 divAssigned">   
                            <asp:DropDownList ID="ddlSection" runat="server" Width="96px" ToolTip="Select Section" ClientIDMode="Static" >
                           </asp:DropDownList>
                        </div>


                        <div class="col-md-3 divAssigned" style="display:none">Assigned To :</div>
                         <div class="col-md-4 divAssigned" style="display:none">
                             <select id="ddlEmployee">

                             </select>
                         </div> 
                        
                        <div class="col-md-3 divForword" style="display:none">Forward To :</div>
                         <div class="col-md-4 divForword" style="display:none">
                             <select id="ddlForwordToDepartment">

                             </select>
                         </div>

                        <div class="col-md-3 divClose" style="display:none">
                            <input type="button" id="btnItemlist" value="Add Consumed Item" onclick="openRestartModel()" />
                         </div>

                        <div class="col-md-3">
                            <input type="button" id="btnUpdate" value="Update" class="ItDoseButton" style="display:none" title="Click To Update" onclick="updatePriority()"/>

                        <input type="button" id="btnReOpen" value="ReOpen" class="ItDoseButton" style="display:none" title="Click To ReOpen" onclick="reOpenTicket()"/>
                             <input type="button" id="btnShowSection_Master" value="Add Section" class="ItDoseButton" style="display:none" title="" onclick="showSection_Master()"/>
                        
                        </div>
                        
                   
                    </div>
                    <div class="row">
                         </div>
                </div>
                    </div><div class="col-md-1"></div></div>
        <div class="POuter_Box_Inventory">
                        <div id="ticketOutput" style="max-height: 600px; overflow-x: auto;"></div>

        </div>
        
           <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row" style="display:none">
                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:Label ID="lbl1" runat="server" Text="Status Closed By :&nbsp;" Style="display: none" ClientIDMode="Static"></asp:Label></label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:Label ID="lblClose" runat="server" ClientIDMode="Static" CssClass="ItDoseLabelSp"></asp:Label>
                    </div>
                        <div class="col-md-5">
                            <asp:Label ID="lblClosedDate" runat="server" Text="Status Closed Date Time :&nbsp;" Style="display: none" ClientIDMode="Static"></asp:Label>
                        </div>
                        <div class="col-md-5">
                            <asp:Label ID="lblDateTime" runat="server" ClientIDMode="Static" CssClass="ItDoseLabelSp"></asp:Label>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-5"><label class="pull-left">
                            <asp:Label ID="lblResponse" runat="server" Text="PreMade Visit Reply :"></asp:Label>
                                              </label><b class="pull-right">:</b></div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlReplyRspnce" Width="150px" ClientIDMode="Static" onchange="bindResponse()" runat="server" ToolTip="Select PreMade Reply"></asp:DropDownList>
                        </div>
                        <div class="col-md-3" ><label class="pull-left">Description</label><b class="pull-right">:</b></div>
                        <div class="col-md-11" >
                            <asp:TextBox ID="txtDecription" ClientIDMode="Static" align="left" runat="server" TextMode="MultiLine" Columns="45" Rows="10" ToolTip="Enter Description" style="height: 60px; width: 568px; margin: 0px;" CssClass="requiredField"></asp:TextBox>
                        </div>
                    </div>
                     </div>
                </div><div class="col-md-1"></div>
                <div class="POuter_Box_Inventory" style="text-align:center">
                        <input type="button" id="btnReply" value="Reply" onclick="replyTicket()" class="ItDoseButton" title="Click To Reply"/></div>
                    <div class="POuter_Box_Inventory" style="text-align:center">
                        <div id="ticketReplyOutput" style="max-height: 600px; overflow-x: auto;"></div>

                    </div>
       
        <div class="POuter_Box_Inventory">
            <div class="row">
                                    <div class="col-md-24" style="text-align: center; max-height: 400px;  overflow: auto;">
                                        <asp:Repeater ID="rpFloor" runat="server" OnItemDataBound="rpFloor_ItemDataBound" OnItemCommand="rpFloor_ItemCommand">
                                            <HeaderTemplate>
                                                <table cellspacing="0" style="border-collapse: collapse; width: 100%;">
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <tr style="text-align: center;background-color:blue;color:white;" runat="server" id="trSectionRow" >
                                                    <td class="GridViewHeaderStyle" style="text-align: left;background-color:blue;color:white;font-size:larger;" >
                                                        <asp:Label ID="lblFloor" Font-Bold="true" runat="server" Text='<%# Eval("Section_Name")%>' CssClass="blue"  />
                                                        <asp:Label ID="lblSection_ID" Font-Bold="true" runat="server" Visible="false" Text='<%# Eval("ID")%>' />
                                                    </td>
                                                </tr>
                                                <tr runat="server" id="trRow"><td>
                                                    <div class="row" style="margin:5px;">
                       
                        <div class="col-md-3"><label class="pull-left">Status</label><b class="pull-right">:</b> </div>
                        <div class="col-md-3">   
                            <asp:DropDownList ID="ddlStatusSub" runat="server" Width="96px" ToolTip="Select Status" ClientIDMode="Static" >
                                 <asp:ListItem Value="4">Assigned</asp:ListItem>
                           <%-- <asp:ListItem Value="1">Process</asp:ListItem>
                           --%> 
                                <asp:ListItem Value="3">Reslove</asp:ListItem>
                            </asp:DropDownList>

                        </div>

                         
                        <div class="col-md-3 " style="">Assigned To :</div>
                         <div class="col-md-4 " style="">
                            <asp:DropDownList ID="ddlAssignToSub" runat="server" Width="96px" ToolTip="Select Assigned To"  ClientIDMode="Static" >
                            </asp:DropDownList>
                         </div> 
                        
                        <div class="col-md-3 " style="display:none">Forward To :</div>
                         <div class="col-md-4 " style="display:none">
                             <select id="Select2">

                             </select>
                         </div>

                        <div class="col-md-3 " style="display:none">
                            <input type="button" id="Button3" value="Add Consumed Item" onclick="openRestartModel()" />
                         </div>

                        <div class="col-md-3">
                            <asp:LinkButton ID="lnkEditCategory" runat="server" CommandName="update" CommandArgument='<%#Container.ItemIndex %>' >
                                 <input type="button" value="Update" class="subticketbutton" />
                            </asp:LinkButton>

                          
                        <input type="button" id="Button5" value="ReOpen" class="ItDoseButton" style="display:none" title="Click To ReOpen" onclick="reOpenTicket()"/>
                             <input type="button" id="Button6" value="Add Section" class="ItDoseButton" style="display:none" title="" onclick="showSection_Master()"/>
                        
                        </div>
                        
                   
                    </div>
                                                    </td></tr>
                                                <tr>
                                                    <td style="text-align: left; background-color: transparent;">
                                                        <asp:Repeater ID="rpBD" runat="server" OnItemDataBound="rpBD_ItemDataBound">
                                                            <HeaderTemplate>
                                                                
                    
                                                                <table cellspacing="0" style="border-collapse: collapse; width: 100%;">
                                                                     <tr id="Tr1">
                  <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Priority</th>
                  <th class="GridViewHeaderStyle" scope="col" style="width:120px;">SubTicket No</th>
                  <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Ticket Type</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Status</th> 
                <th class="GridViewHeaderStyle" scope="col" style="width:260px;">Entry By</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:260px;">Entry Date</th>
                 <th class="GridViewHeaderStyle" scope="col" style="width:260px;">Section</th>  
                 <th class="GridViewHeaderStyle" scope="col" style="width:260px;">Assigned To</th>         
            </tr>
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <tr>
                                                                    <td class="GridViewStyle" style="color: #800080; text-align: left; background-color: transparent; width: 150px;">
                                                                     <%# Eval("Priority")%> </td>
                                                                    <td class="GridViewStyle" style="color: #800080; text-align: left; background-color: transparent; width: 150px;">
                                                                     <%# Eval("TicketNo")%> </td>
                                                                    <td class="GridViewStyle" style="color: #800080; text-align: left; background-color: transparent; width: 150px;">
                                                                     Child </td>
                                                                    <td class="GridViewStyle" style="color: #800080; text-align: left; background-color: transparent; width: 150px;">
                                                                     <%# Eval("Status")%> </td>
                                                                    <td class="GridViewStyle" style="color: #800080; text-align: left; background-color: transparent; width: 150px;">
                                                                     <%# Eval("CreatedBy")%> </td>
                                                                    <td class="GridViewStyle" style="color: #800080; text-align: left; background-color: transparent; width: 150px;">
                                                                     <%# Eval("CreatedDate")%> </td>
                                                                    <td class="GridViewStyle" style="color: #800080; text-align: left; background-color: transparent; width: 150px;">
                                                                     <%# Eval("Section_Name")%> </td>
                                                                    <td class="GridViewStyle" style="color: #800080; text-align: left; background-color: transparent; width: 150px;">
                                                                     <%# Eval("Assigned_Engineer")%> </td>
                                                                    <td class="GridViewStyle" style="font-weight: bold; text-align: left;">
                                                                       
                                                                    </td>
                                                                </tr>
                                                            </ItemTemplate>
                                                            <FooterTemplate>
                                                                </table>
                                                            </FooterTemplate>
                                                        </asp:Repeater>
                                                    </td>
                                                </tr>
                                            </ItemTemplate>
                                            <FooterTemplate>
                                                </table>
                                            </FooterTemplate>
                                        </asp:Repeater>
                                    </div>
                                </div>
        </div>
               <div class="POuter_Box_Inventory" style="display:none;">
                        <div id="divReply" style="max-height: 600px; overflow-x: auto;"></div>

        </div>
           </div>



            <div class="modal fade" id="myModal" >
            <div class="modal-dialog">

                <!-- Modal content-->
                <div class="modal-content" style="width: 800px">
                    <div class="modal-header">
                        <button type="button" class="close" onclick="$closeRestartModel()" aria-hidden="true">&times;</button>
                        <h4 class="modal-title">Add Item List</h4>
                    </div>
                    <div class="modal-body">
                      
                        <div class="row">
                         <label id="lblTicketIdItemSupply" style="display:none"></label>
                             
                            <div class="row">
                                <div class="col-md-4">
                                    Item Name :
                                </div>
                                  <div class="col-md-20">
                                      
                                      <input  type="text" id="txtItemName" class="requiredField"/>
                                </div>
                            

                           </div>

                            <div class="row">

                                    <div class="col-md-4">
                                    Used Qty/Hrs :
                                </div>
                                  <div class="col-md-6">
                                       <input  type="number" id="txtusedQty" value="0"  class="requiredField"/>
                                </div>
                                <div class="col-md-3">
                                   Rate :
                                </div>
                                  <div class="col-md-6">
                                       <input  type="number" id="txtRate" class="requiredField" value="0"  />
                                </div>
                              
                                <div class="col-md-3">
                                    <input type="button" id="btnAdd" onclick="AddRow()" value="Add" />
                                </div>

                            </div>

                         </div>

                           <div class="row" id="DivOrderDetails" style="max-height: 400px; overflow-y: auto; overflow-x: hidden; display:none">
                        
                             <table class="FixedHeader" id="tblItemDetails" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                        <thead>
                            <tr>
                                <th class="GridViewHeaderStyle" style="width: 30px;">SrNo</th>
                                <th class="GridViewHeaderStyle" style="width: 100px;">Item Name</th> 
                                <th class="GridViewHeaderStyle" style="width: 100px;">Qty</th>
                                <th class="GridViewHeaderStyle" style="width: 100px;">Rate</th>
                                <th class="GridViewHeaderStyle" style="width: 100px;">Total</th>
                                <th class="GridViewHeaderStyle" style="width: 50px;">Action</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>

                          </div>
                    </div>
                    <div class="modal-footer">
                        <input type="button" id="btnSendReply"  value="Save" onclick="SaveItemDetails()"  />
                    </div>
                </div>

            </div>
                </div>
       

    <div class="modal fade" id="divSection_Master" >
            <div class="modal-dialog">

                <!-- Modal content-->
                <div class="modal-content" style="width: 800px">
                    <div class="modal-body">
                     <div class="POuter_Box_Inventory" style="text-align: center;width:100%;">
            <b>Add Section </b><br />
            <asp:Label ID="Label1" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;width:100%;">
            <div class="row">
               <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-4"><label class="pull-left">Section Name</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <input type="text"  class="requiredField" id="txtSection_Name" style="width: 200px" tabindex="2"  title="Enter Section Name"  />
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">
                                Status
                            </label><b class="pull-right">:</b></div>
                        <div class="col-md-8">
                            <asp:RadioButtonList ID="rbtnStatus" runat="server" RepeatDirection="Horizontal" TabIndex="3" ToolTip="Select Status">
                            <asp:ListItem Selected="True" Value="1">Active</asp:ListItem>
                            <asp:ListItem Value="0">InActive</asp:ListItem>
                        </asp:RadioButtonList>
                        </div>

                        <div class="col-md-3" style="display:none">
                            <input type="button" id="btnNew" tabindex="4" value="New" onclick="ShowModalPopupp()" class="ItDoseButton" title="Add New Info" />
                        </div>
                    </div>
                </div>
            </div>
            
            
        </div>
        <div class="POuter_Box_Inventory"  style="text-align: center;width:100%;">
                        <input type="button" id="btnSave" tabindex="4" value="Save" class="ItDoseButton" onclick="errorTypeCon()" title="Click To Submit" />
                        <input type="button" id="btnCancel" value="Cancel" tabindex="5" class="ItDoseButton" style="display: none" onclick="cancelErrorType()" title="Click To Cancel" />
                </div>
        
            <div class="POuter_Box_Inventory" style="text-align: center;width:100%;">Sections</div>
                        <div id="ErrorTypeOutput" style=""></div>

                    </div>
                    
                    <div class="modal-footer">
                        
                        <input type="button" id="Button1"  value="Close" onclick="$('#divSection_Master').hide();"  />
                     </div>
                </div>

            </div>
                </div>
     
     <script id="tb_SearchErrorType" type="text/html">
        <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdErrorType" style="width:100%;border-collapse:collapse;">
            <tr id="Tr3">
			    <th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:250px;">Section Name</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:90px;">Status</th>	
                <th class="GridViewHeaderStyle" scope="col" style="width:60px;">EntryBy</th>			 
                <th class="GridViewHeaderStyle" scope="col" style="width:30px;display:none;">Edit</th>           
            </tr>
            <#       
                var dataLength=errorType.length;
                window.status="Total Records Found :"+ dataLength;
                var objRow; 
                var num;  
                
                for(var j=0;j<dataLength;j++)
                {       
                    objRow = errorType[j];
                    num=<#=j+1#>;
            #>
            <tr id="Tr4">                            
                    <td class="GridViewLabItemStyle" style="width:10px;text-align:center;"><#=j+1#>
                        
                    </td>
                    <td class="GridViewLabItemStyle" id="tdSection_Name"  style="width:250px;text-align:center" ><#=objRow.Section_Name#></td>
                    <td class="GridViewLabItemStyle" id="tdID"  style="width:250px;text-align:center;display:none;" ><#=objRow.ID#></td>
                    
                    <td class="GridViewLabItemStyle" id="tdIsActive"  style="width:90px;text-align:center" ><#=objRow.IsActive#></td>
                    <td class="GridViewLabItemStyle" id="tdEmployeeID" style="width:60px;">
                    <#=objRow.EntryBy#>
                </td>
                    <td class="GridViewLabItemStyle" style="width:30px; text-align:center;display:none;">
                        <input type="button" value="Edit"   id="btnEdit"  class="ItDoseButton" onclick="editErrorType(this);" title="Click To Edit"/>                                                    
                    </td>                    
            </tr>            
            <#}#>     
        </table>    
    </script>
   






    <script id="tb_ticket" type="text/html">
        <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdticket" style="width:99%;border-collapse:collapse;">
            <tr id="Header">
                <th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Name</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Reply Date Time</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:300px;">Description</th>  
                <th class="GridViewHeaderStyle" scope="col" style="width:300px;">Reply From</th>                     
		    </tr>
            <#       
                var dataLength=ticket.length;
                window.status="Total Records Found :"+ dataLength;
                var objRow;   
                for(var j=0;j<dataLength;j++)
                {       
                    objRow = ticket[j];
            #>
            <tr id="<#=j+1#>">                            
                <td class="GridViewLabItemStyle" style="width:10px;"><#=j+1#></td>
                <td class="GridViewLabItemStyle" id="tdName"  style="width:120px;text-align:center" ><#=objRow.Name#></td>
                <td class="GridViewLabItemStyle" id="tdReply_Time"  style="width:140px;text-align:center" ><#=objRow.REPLY_TIME#></td>
                <td class="GridViewLabItemStyle" id="tdDescription"  style="width:300px;text-align:center" ><#=objRow.DESCRIPTION#></td>
               <td class="GridViewLabItemStyle" id="tdReplyFromName"  style="width:300px;text-align:center" ><#=objRow.ReplyFromName#></td>
            
            
            </tr>            
            <#}#>      
        </table>    
    </script>

    <script type="text/javascript">
        function saveErrorType() {
            $("#btnSave").val("Submitting...").attr("disabled");


            if ($.trim($("#txtSection_Name").val()) == "") {
                $("#btnSave").val("Save").removeAttr("disabled", "disabled");
                //$("#lblErrormsg").text('Please Enter Error Type');
                modelAlert("Please Enter Section Name");
                $("#txtSection_Name").focus();
                return;
            }

            $.ajax({
                type: "POST",
                url: "Services/HelpDesk.asmx/saveSection",
                data: '{Section_Name:"' + $.trim($("#txtSection_Name").val()) + '",Status:"' + $("#<%=rbtnStatus.ClientID%> input[type:radio]:checked").val() + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: false,
                success: function (response) {
                    errorType = (response.d);
                    if (errorType != null && response.d == "1") {
                        errorTypeSearch();
                       // cancelErrorType();
                       // DisplayMsg('MM01', 'lblErrormsg');
                    }
                    else if (errorType != null && response.d == "2") {
                        $("#lblErrormsg").text("Error Type Already Exist");
                        $("#txtErrorType").focus();
                    }
                    else {
                        DisplayMsg('MM05', 'lblErrormsg');
                    }
                    $("#btnSave").val("Save").removeAttr("disabled");
                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'lblErrormsg');
                    window.status = status + "\r\n" + xhr.responseText;
                    $("#btnSave").val("Save").removeAttr("disabled");
                }
            });
        }
        function errorTypeSearch() {
            $.ajax({
                type: "POST",
                url: "Services/HelpDesk.asmx/sectionSearch",
                data: '{}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: false,
                success: function (response) {
                    errorType = jQuery.parseJSON(response.d);
                    if (errorType != null && response.d != "") {
                        var output = $('#tb_SearchErrorType').parseTemplate(errorType);

                        $('#ErrorTypeOutput').html(output);
                        $('#ErrorTypeOutput').show();

                        var num = 1;
                        /* $.each(errorType, function (i, v) {
                             var emp = v.EmployeeID;
                             var match = emp.split(",");
                             var m = "";
                             $.each(match, function (i) {
                                 $.ajax({
                                     type:"POST",
                                     url: 'ErrorType.aspx/GetEmployeename',
                                     data: '{EmployeeID:"' + $('#ddlEmployee').val() + '"}',
                                     dataType: "json",
                                     contentType: "application/json;charset=UTF-8",
                                     async: false,
                                 }).done(function (r) {
                                     var nam = JSON.parse(r.d);
                                      m += nam + ",";
                                 });
                             });
                             m = m.slice(0, -1);
                             $("#cls_" + num).text(m);
                             num++;
                         });*/
                    }
                    else {
                        $('#ErrorTypeOutput').hide();
                    }
                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'lblErrormsg');
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }

        function errorTypeCon() {
            if ($("#btnSave").val() == "Save") {
                $("#lblErrormsg").text('');
                saveErrorType();
            }
            else {
                $("#lblErrormsg").text('');
               // updateErrorType(rowID);
            }
        }

        function reOpenTicket() {
            if ($.trim($("#txtReopenReason").val()) != "") {
                $.ajax({
                    type: "POST",
                    url: "Services/HelpDesk.asmx/reopenTicket",
                    data: '{TicketId:"' + TicketId + '",ReopenPriority:"' + $("#ddlPriority option:selected").text() + '",ReopenPriorityID:"' + $("#ddlPriority").val() + '",Reason:"' + $.trim($("#txtReopenReason").val()) + '"}',
                    dataType: "json",
                    contentType: "application/json;charset=UTF-8",
                    async: false,
                    success: function (response) {
                        ticket = response.d;
                        if (ticket == "1") {
                            DisplayMsg('MM01', 'lblErrormsg');
                            //$("#btnReply").attr("disabled", "disabled");
                            //$("#btnReOpen").attr("disabled", "disabled");
                            //bindTicketDetail();
                            //bindTicketInfo();
                            window.location.reload();
                        }
                        else {
                            DisplayMsg('MM05', 'lblErrormsg');
                        }
                    },
                    error: function (xhr, status) {
                        DisplayMsg('MM05', 'lblErrormsg');
                    }
                });
            }
            else {
                $("#lblErrormsg").text('Please Enter ReOpen Reason ');
                $("#txtReopenReason").focus();
            }
        }

        function bindTicketInfo() {
            $.ajax({
                type: "POST",
                url: "Services/HelpDesk.asmx/ticketDetail",
                data: '{TicketID:"' + TicketId + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: false,
                success: function (response) {
                    ticketDetails = jQuery.parseJSON(response.d);
                    if (ticketDetails != null) {
                        var output = $('#tbticketDetail').parseTemplate(ticketDetails);
                        $('#ticketOutput').html(output);
                        $('#ticketOutput').show();
                    }
                    else {
                        $('#ticketOutput').hide();
                    }
                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'lblErrormsg');
                }
            });
        }
        function bindTicketInfoReply() {
            $.ajax({
                type: "POST",
                url: "Services/HelpDesk.asmx/ticketDetailReply",
                data: '{TicketID:"' + TicketId + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: false,
                success: function (response) {
                    ticketDetails = jQuery.parseJSON(response.d);
                    if (ticketDetails != null) {
                        var output = $('#tblReplyTicketDetail').parseTemplate(ticketDetails);
                        $('#divReply').html(output);
                        $('#divReply').show();
                    }
                    else {
                        $('#divReply').hide();
                    }
                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'lblErrormsg');
                }
            });
        }

        </script>
    <script id="tbticketDetail" type="text/html">
        <table class="FixedTables" cellspacing="0" rules="all" border="1" id="Table1" style="border-collapse:collapse;">
            <tr id="Tr1">
                <th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
                  <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Priority</th>
                  <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Ticket No</th>
                  <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Ticket Type</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Status</th> 
                <th class="GridViewHeaderStyle" scope="col" style="width:260px;">Entry By</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:260px;">Entry Date</th>
                 <th class="GridViewHeaderStyle" scope="col" style="width:260px;">Section</th>  
                 <th class="GridViewHeaderStyle" scope="col" style="width:260px;">Assigned To</th>  
                   <th class="GridViewHeaderStyle" scope="col" style="width:260px;">Forworded To</th>  
                <th class="GridViewHeaderStyle" scope="col" style="width:260px;">Reopen Reason</th>         
            </tr>
            <#       
                var dataLength=ticketDetails.length;
                var objRow;   
                for(var j=0;j<dataLength;j++)
                {       
                    objRow = ticketDetails[j];
            #>
            <tr id="Tr2">                            
                <td class="GridViewLabItemStyle" style="width:10px;"><#=j+1#></td>
                 <td class="GridViewLabItemStyle" style="width:120px;text-align:center"><#=objRow.Priority#></td>
                 <td class="GridViewLabItemStyle" style="width:120px;text-align:center"><#=objRow.TicketID#></td>
                 <td class="GridViewLabItemStyle" style="width:120px;text-align:center"><#=objRow.Ticket#></td>
                <td class="GridViewLabItemStyle" style="width:120px;text-align:center"><#=objRow.Status#></td>               
                <td class="GridViewLabItemStyle" style="width:260px;text-align:center"><#=objRow.CreatedBy#></td>
                  <td class="GridViewLabItemStyle" style="width:260px;text-align:center"><#=objRow.CreatedDate#></td>
               <td class="GridViewLabItemStyle" style="width:260px;text-align:center"><#=objRow.Section_Name#></td>
               <td class="GridViewLabItemStyle" style="width:260px;text-align:center"><#=objRow.Assign_Engineer#></td>
                <td class="GridViewLabItemStyle" style="width:260px;text-align:center"><#=objRow.ForwordToDepartment#></td>
                 <td class="GridViewLabItemStyle" style="width:120px;text-align:center"><#=objRow.Reason#></td>
                
              
            </tr>            
            <#}#>      
        </table>    
    </script>
    <script id="tblReplyTicketDetail" type="text/html">
        <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb1" style="border-collapse:collapse;">
            <tr id="Tr5">
                <th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
                  <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Priority</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Status</th> 
                <th class="GridViewHeaderStyle" scope="col" style="width:260px;">Entry By</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:260px;">Entry Date</th>
                 <th class="GridViewHeaderStyle" scope="col" style="width:260px;">Section</th>  
                 <th class="GridViewHeaderStyle" scope="col" style="width:260px;">Assigned To</th>        
            </tr>
            <#       
                var dataLength=ticketDetails.length;
                var objRow;   
                for(var j=0;j<dataLength;j++)
                {       
                    objRow = ticketDetails[j];
            #>
            <tr id="Tr6">                            
                <td class="GridViewLabItemStyle" style="width:10px;"><#=j+1#></td>
                 <td class="GridViewLabItemStyle" style="width:120px;text-align:center"><#=objRow.Priority#></td>
                <td class="GridViewLabItemStyle" style="width:120px;text-align:center"><#=objRow.Status#></td>               
                <td class="GridViewLabItemStyle" style="width:260px;text-align:center"><#=objRow.CreatedBy#></td>
                  <td class="GridViewLabItemStyle" style="width:260px;text-align:center"><#=objRow.CreatedDate#></td>
               <td class="GridViewLabItemStyle" style="width:260px;text-align:center"><#=objRow.Section_Name#></td>
               <td class="GridViewLabItemStyle" style="width:260px;text-align:center"><#=objRow.Assigned_Engineer#></td>
                
              
            </tr>            
            <#}#>      
        </table>    
    </script>
    <script type="text/javascript">
        function enableSection()
        {
            $("#spanIsSubTicket").text("1");
            $('#<%=ddlSection.ClientID %>').prop('disabled', false);
        }


        function HideShowOnStatus(Type) {

            if (Type == "4") {
                document.getElementById('StatusClose').style.display = "none";
                $(".divAssigned").show();
                $(".divForword").hide();
                $(".divClose").hide();
                bindToEmployee();
            } else if (Type == "5") {
                document.getElementById('StatusClose').style.display = "none";
                $(".divAssigned").hide();
                $(".divForword").show();
                $(".divClose").hide();
                bindForwordToDepartment();
            }
            else if (Type == "2") {
                document.getElementById('StatusClose').style.display = "";
                $(".divAssigned").hide();
                $(".divForword").hide();
                $(".divClose").show();
            } else {
                document.getElementById('StatusClose').style.display = "none";
                $(".divAssigned").hide();
                $(".divForword").hide();
                $(".divClose").hide();
            }

        }
        function bindToEmployeeP() {
            $('#lblErrormsg').text('');
            var ProjectSupervisor = $("#ddlProjectSupervisor");
            $("#ddlProjectSupervisor option").remove();
            $.ajax({
                url: "Services/HelpDesk.asmx/bindAssignedToEmployee",
                data: '{}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    Data = jQuery.parseJSON(result.d);
                    if (Data.length == 0) {
                        ProjectSupervisor.append($("<option></option>").val("0").html("---No Data Found---"));
                        }
                    else {
                        ProjectSupervisor.append($("<option></option>").val(0).html("Select"));
                        for (i = 0; i < Data.length; i++) {
                            ProjectSupervisor.append($("<option></option>").val(Data[i].Id).html(Data[i].EmpName));
                         }
                    }
                    //ProjectSupervisor.chosen();
                   // Employee.attr("disabled", false);
                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'lblErrormsg');
                    Priority.attr("disabled", false);
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }


        function bindToAssignedTo() {
            $('#lblErrormsg').text('');
            var Employee = $("#ddlEmployee");
            $("#ddlEmployee option").remove();
            $.ajax({
                url: "Services/HelpDesk.asmx/bindAssignedToEmployee",
                data: '{}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    Data = jQuery.parseJSON(result.d);
                    if (Data.length == 0) {
                        Employee.append($("<option></option>").val("0").html("---No Data Found---"));
                    }
                    else {
                        Employee.append($("<option></option>").val(0).html("Select"));
                        for (i = 0; i < Data.length; i++) {
                            Employee.append($("<option></option>").val(Data[i].Id).html(Data[i].EmpName));
                        }
                    }
                   // Employee.chosen();
                    //ProjectSupervisor.chosen();
                    Employee.attr("disabled", false);
                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'lblErrormsg');
                    Priority.attr("disabled", false);
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }

        function bindToEmployee() {
            $('#lblErrormsg').text('');
            var Employee = $("#ddlEmployee");
            $("#ddlEmployee option").remove();
            $.ajax({
                url: "Services/HelpDesk.asmx/bindAssignedToEmployee",
                data: '{}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    Data = jQuery.parseJSON(result.d);
                    if (Data.length == 0) {
                        Employee.append($("<option></option>").val("0").html("---No Data Found---"));
                    }
                    else {
                        Employee.append($("<option></option>").val(0).html("Select"));
                        for (i = 0; i < Data.length; i++) {
                            Employee.append($("<option></option>").val(Data[i].Id).html(Data[i].EmpName));
                        }
                    }
                   // Employee.chosen();
                    //ProjectSupervisor.chosen();
                    Employee.attr("disabled", false);
                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'lblErrormsg');
                    Priority.attr("disabled", false);
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }

        function bindForwordToDepartment() {
            $('#lblErrormsg').text('');
            var ForwordDepartment = $("#ddlForwordToDepartment");
            $("#ddlForwordToDepartment option").remove();
            $.ajax({
                url: "Services/HelpDesk.asmx/bindForwordDepartment",
                data: '{}', // parameter map
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    Data = jQuery.parseJSON(result.d);
                    if (Data.length == 0) {
                        ForwordDepartment.append($("<option></option>").val("0").html("---No Data Found---"));
                    }
                    else {
                        ForwordDepartment.append($("<option></option>").val(0).html("Select"));
                        for (i = 0; i < Data.length; i++) {
                            ForwordDepartment.append($("<option></option>").val(Data[i].ID).html(Data[i].Name));
                        }
                    }
                    ForwordDepartment.chosen();
                    ForwordDepartment.attr("disabled", false);
                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'lblErrormsg');
                    Priority.attr("disabled", false);
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }



        </script>



    
        <script type="text/javascript">
            var openRestartModel = function () {

                var TicketID = '<%=Util.GetString(Request.QueryString["TicketId"].ToString())%>';
                $("#lblTicketIdItemSupply").text(TicketID);
                BindSavedItem(TicketID);
                $("#myModal").showModel();
            }
            function showSection_Master()
            {
                errorTypeSearch();
                $("#divSection_Master").showModel();
            }

            var $closeRestartModel = function () {
                $("#lblTicketIdItemSupply").text("");
                $('#tblItemDetails tbody').empty();
                Clear();
                $("#myModal").hideModel();

            }

            function AddRow() {
                var ItemName = $("#txtItemName").val();
                var UsedQty = $("#txtusedQty").val();
                var Rate = $("#txtRate").val();

                if (ItemName == '' || ItemName == "" || ItemName == undefined || ItemName == null) {
                    modelAlert("Enter Item Name.")
                    return false;
                }
                if (UsedQty == '' || UsedQty == "0" || UsedQty == undefined || UsedQty == null) {
                    modelAlert("Enter Consumed Qty.")
                    return false;
                }
                if (Rate == '' || Rate == "0" || Rate == undefined || Rate == null) {
                    modelAlert("Enter Rate of One Item.")
                    return false;
                }

                AddNewRow(ItemName, UsedQty, Rate);
            }


            function AddNewRow(ItemName, UsedQty, Rate) {

                if (ItemName == '' || ItemName == "" || ItemName == undefined || ItemName == null) {
                    modelAlert("Enter Item Name.")
                    return false;
                }
                if (UsedQty == '' || UsedQty == "0" || UsedQty == undefined || UsedQty == null) {
                    modelAlert("Enter Consumed Qty.")
                    return false;
                }
                if (Rate == '' || Rate == "0" || Rate == undefined || Rate == null) {
                    modelAlert("Enter Rate of One Item.")
                    return false;
                }

                var Total = parseFloat(UsedQty) * parseFloat(Rate)


                var Length = $('#tblItemDetails tbody tr').length;


                var row = '<tr>';
                row += '<td id="tdsno"  class="GridViewLabItemStyle" style="text-align: center;">' + ++Length + '</td>';
                row += '<td id="tdTicketId" class="GridViewLabItemStyle" style="text-align: center; display:none">' + $("#lblTicketIdItemSupply").text() + '</td>';
                row += '<td  id="tdItemName" class="GridViewLabItemStyle" >' + ItemName + '</td>';
                row += '<td  id="tdQty" class="GridViewLabItemStyle" style="text-align: center;">' + UsedQty + '</td>';
                row += '<td  id="tdRate" class="GridViewLabItemStyle" style="text-align: center;">' + Rate + '</td>';
                row += '<td  id="tdTotal" class="GridViewLabItemStyle" style="text-align: center;">' + Total + '</td>';
                row += '<td  id="tdRemove" class="GridViewLabItemStyle" style="text-align: center;"><input type="button" value="Remove" id="btnRemove" onclick="Remove(this)" /></td>';

                row += '</tr>';

                $('#tblItemDetails tbody').append(row);
                Clear();
            }

            function Clear() {
                hideShowTable()
                $("#txtItemName").val("");
                $("#txtusedQty").val("0");
                $("#txtRate").val("0");
            }



            var Remove = function (elem) {
                modelConfirmation('Delete Confirm ?', 'Do you want to Remove Item.', 'Yes', 'No', function (response) {
                    if (response) {
                        $(elem).closest('tr').remove();
                        hideShowTable();
                    }
                });
            }


            function hideShowTable() {

                var Length = $('#tblItemDetails tbody tr').length;
                if (Length > 0) {
                    $("#DivOrderDetails").show();
                } else {
                    $("#DivOrderDetails").hide();
                }

            }




            function SaveItemDetails() {

                if ($('#tblItemDetails tbody tr').length < 1) {

                    modelAlert("Please Add Item in LIst");
                    return false;
                }

                var dataItemSave = new Array();
                var NewObj = new Object();
                $('#tblItemDetails tbody tr').each(function () {
                    var id = $(this).attr("id");
                    var $rowid = $(this).closest("tr");
                    NewObj.TicketId = $rowid.find("#tdTicketId").text();
                    NewObj.ItemNmae = $rowid.find("#tdItemName").text();
                    NewObj.Qty = $rowid.find("#tdQty").text();
                    NewObj.Rate = $rowid.find("#tdRate").text();
                    NewObj.Total = $rowid.find("#tdTotal").text();
                    dataItemSave.push(NewObj);
                    NewObj = new Object();

                });

                serverCall('Services/HelpDesk.asmx/SaveItemList', { data: dataItemSave }, function (response) {
                    var responseData = JSON.parse(response);
                    if (responseData.status) {
                        modelAlert(responseData.Message, function () {
                            $closeRestartModel();
                        });

                    }
                    else {

                        modelAlert(responseData.Message);
                    }
                });

            }



            function BindSavedItem(TickId) {
                serverCall('Services/HelpDesk.asmx/BindSavedItem', { TickId: TickId }, function (response) {
                    var responseData = JSON.parse(response);
                    if (responseData.status) {
                        data = responseData.data;
                        $.each(data, function (i, item) {
                            AddNewRow(item.ItemName, item.Qty, item.Rate)
                        });


                    }
                    
                });
            }


</script>
</asp:content>
