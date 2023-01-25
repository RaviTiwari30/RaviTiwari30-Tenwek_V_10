<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="AssignTicket.aspx.cs" Inherits="Design_HelpDesk_AssignTicket" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="DropDownCheckBoxes" Namespace="Saplin.Controls" TagPrefix="asp" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    
    <style type="text/css">
         .requiredField1 {
            border-radius:4px;
            width:100%;
            height:23px !important;
        }
        .Disabl {
            display:none;
        }
    </style>

    <script type="text/javascript">
        $(document).ready(function () {
           // $('#ddlemployee').chosen();
        });
    </script>

    <div id="Pbody_box_inventory">
        <%--<asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>--%>
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" EnableScriptGlobalization="true"
        EnableScriptLocalization="true">
    </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Assign Ticket </b>
            <br />
            <asp:Label ID="lblErrormsg" ClientIDMode="Static" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
             Assign Ticket  &nbsp;
            </div>
            <div class="row">
                 <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">From Date</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFromDate"  runat="server" ClientIDMode="Static" ToolTip="Click To Select To Date" CssClass="requiredField" autocomplete="off"></asp:TextBox>
                            <cc1:calendarextender id="ToDatecal" targetcontrolid="txtFromDate" format="dd-MMM-yyyy"
                                animated="true" runat="server">
                            </cc1:calendarextender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">To Date</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtToDate"  runat="server" ClientIDMode="Static" ToolTip="Click To Select To Date" CssClass="requiredField" autocomplete="off"></asp:TextBox>
                                    <cc1:calendarextender id="Calendarextender1" targetcontrolid="txtToDate" format="dd-MMM-yyyy"
                                        animated="true" runat="server">
                                    </cc1:calendarextender>
                        </div>
                         <div class="col-md-3">
                            <label class="pull-left">From Dept</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                              <asp:DropDownList ID="ddlDepartment" runat="server" OnSelectedIndexChanged="ddlDepartment_SelectedIndexChanged"></asp:DropDownList>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Error Type</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlErrorType" runat="server"></asp:DropDownList>
                        </div>
                        <%--<div class="col-md-3">
                            <label class="pull-left">Status</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownCheckBoxes ID="ddlStatus" runat="server" AddJQueryReference="True" UseButtons="false" UseSelectAllNode="True" Height="23px" CssClass="requiredField requiredField1">
                                <Texts SelectBoxCaption="Select all" />
                            </asp:DropDownCheckBoxes>
                        </div>--%>
                    </div>
                </div>
            </div>
        </div>

        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                <Triggers>
                    <asp:asyncpostbacktrigger controlid="btnSearch" eventname="click"/>
                </Triggers>
                <ContentTemplate>
                    <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click" CssClass="ItDoseButton" />
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>

    <div class="POuter_Box_Inventory">
        <table style="width: 100%; border-collapse: collapse">
            <tr>
                <td colspan="4" style="text-align: left">
                    <asp:UpdatePanel runat="server" ID="up2">
                        <ContentTemplate>
                            <asp:GridView ID="dgGrid" runat="server" AutoGenerateColumns="false" CssClass="GridViewStyle" OnRowDataBound="dgGrid_RowDataBound" ClientIDMode="Static"
                                 OnRowCommand="dgGrid_RowCommand" DataKeyNames="EmployeeID" >
                                <Columns>
                                    <asp:TemplateField HeaderText="S.No.">
                                        <ItemTemplate>
                                            <%#Container.DataItemIndex+1 %>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewLabItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="From Dept.">
                                        <ItemTemplate>
                                            <%#Eval("RoleName") %>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewLabItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="240px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Description">
                                        <ItemTemplate>
                                            <%#Eval("Description") %>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewLabItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="240px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Asset Name">
                                        <ItemTemplate>
                                            <%#Eval("TypeName") %>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewLabItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="240px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Date">
                                        <ItemTemplate>
                                            <%#Eval("Date") %>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewLabItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="240px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Status">
                                        <ItemTemplate>
                                            <asp:Label ID="lblEmployeeID" runat="server" Text='<%#Eval("EmployeeID")%>' Visible="false"></asp:Label>
                                            <asp:Label ID="lblticketID" runat="server" Text='<%#Eval("TicketID") %>' Visible="false"></asp:Label>
                                            <asp:Label ID="lblStatus" runat="server"></asp:Label>
                                            <asp:Label ID="lblIsAssign" runat="server" Visible="false" Text='<%#Eval("IsticketAssign") %>'></asp:Label>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewLabItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="240px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="View Attachment">
                                        <ItemTemplate>
                                            <%#Eval("Attachment_Name") %>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewLabItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="240px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Assigned">
                                        <ItemTemplate>
                                            <%--<asp:ImageButton ID="ibmTransfer" runat="server" CausesValidation="false" CommandName="AEdit" ImageUrl="Transfer" /> --%>
                                            
                                            <asp:Button ID='ibmTransferss' runat="server" CausesValidation="false" CommandName='<%#Eval("TicketID") %>' CommandArgument='<%#Eval("StockID")%>' Text="Assign" CssClass='<%#Eval("IsAssign")%>'  />
                                            
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewLabItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="240px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="View Log">
                                        <ItemTemplate>
                                            <asp:Button runat="server" ID="btnView" Text="View" CausesValidation="false" CommandName='btnView' CommandArgument='<%#Eval("TicketID") %>' />
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewLabItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                                    </asp:TemplateField>
                                    <%--<asp:TemplateField HeaderText="Assigned">StockID
                                        <ItemTemplate>
                                            
                                            <asp:Button ID="ibmEdit" runat="server" CausesValidation="false" CommandName="AEdit" CommandArgument='<%#Eval("AssetName")%>' Text="Assigned"/> 
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewLabItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="240px" />
                                    </asp:TemplateField>--%>
                                </Columns>
                            </asp:GridView>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
        </table>
    </div>
     <div style="display: none;">
        <asp:Button ID="btnHidden" runat="server" CssClass="ItDoseButton"/>
    </div>
    <asp:Panel ID="palne1" runat="server" BackColor="White">
        <div class="Purchaseheader" id="Div2" runat="server">
            Asset Details
        </div>
        <div class="content" style="margin-left: 10px">
            <table style="width: 100%;">
                <tr>
                    <td colspan="2" >

                    </td>
                </tr>
                <tr>
                    <td style=" text-align:right">
                        Asset Name :
                    </td>
                    <td style="">
                        <asp:Label ID="lblAssetName" runat="server" CssClass="ItDoseLabelSp" />
                    </td>
                    <td style=" text-align:right">
                        Serial No. :
                    </td>
                    <td>
                        <asp:Label ID="lblSerial" runat="server"></asp:Label>
                    </td>
                </tr>
                 <tr>
                    <td style=" text-align:right">
                        Model No :
                    </td>
                    <td style="">
                        <asp:Label ID="lblModelNo" runat="server" CssClass="ItDoseLabelSp" />
                    </td>
                    <td style=" text-align:right">
                        Asset No. :
                    </td>
                    <td>
                        <asp:Label ID="lblAssetNo" runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style=" text-align:right">
                        Warranty To:&nbsp;
                    </td>
                    <td style="">
                        <asp:Label ID="lblWarnty" runat="server"></asp:Label>  
                    </td>
                    <td style=" text-align:right">
                        Vendor Name :
                    </td>
                    <td>
                        <asp:Label ID="lblvendpr" runat="server"></asp:Label>
                    </td>
                </tr>
                <tr style="display:none">
                    <td style="text-align:right">
                        Warrenty Status :&nbsp;
                    </td>
                    <td style="">
                        <asp:Label ID="lblwarentystatus" runat="server"></asp:Label>   
                    </td>
                    <td style="text-align:right">
                        Warrenty No. :&nbsp;
                    </td>
                    <td>
                        <asp:Label ID="lblWarentyNo" runat="server"></asp:Label>
                    </td>
                </tr>
                <tr style="display:none">
                    <td style="text-align:right">
                        AMC Status :&nbsp;
                    </td>
                    <td>
                        <asp:Label ID="lblAmcStatus" runat="server"></asp:Label>
                    </td>
                    <td style="text-align:right">
                        AMC No. :&nbsp;
                    </td>
                    <td>
                        <asp:Label ID="lblamcno" runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="text-align:right">
                        AMC Date :&nbsp;
                    </td>
                    <td>
                        <asp:Label ID="lblamcdate" runat="server"></asp:Label>
                    </td>
                    <td style="text-align:right">
                        AMC Vendor :&nbsp;
                    </td>
                    <td>
                        <asp:Label ID="lblamcvendor" runat="server"></asp:Label>
                    </td>
                </tr>
                <tr style="display:none">
                    <td style="text-align:right">
                        CMC Status :&nbsp;
                    </td>
                    <td>
                        <asp:Label ID="lblCMCstatus" runat="server"></asp:Label>
                    </td>
                    <td style="text-align:right">
                        CMC Date :&nbsp;
                    </td>
                    <td>
                        <asp:Label ID="lblCMCDate" runat="server"></asp:Label>
                    </td>
                </tr>
                <tr style="display:none">
                    <td style="text-align:right">
                        CMC Vendor :&nbsp;
                    </td>
                    <td>
                        <asp:Label ID="lblCMCVendor" runat="server"></asp:Label>
                    </td>
                    <td style="text-align:right">
                        CMC No :&nbsp;
                    </td>
                    <td>
                        <asp:Label ID="lblCMCNo" runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    
                    <td style=" text-align:right">
                        Handled By :
                    </td>
                    <td>
                        <asp:HiddenField ID="hfStockID" runat="server" />
                        <asp:HiddenField ID="hfTicketId" runat="server" />
                        <asp:DropDownList ID="ddlemployee" runat="server" ClientIDMode="Static"></asp:DropDownList>
                    </td>
                </tr>
            </table>
        </div>
        <div class="filterOpDiv">
            <input type="button" id="btnEditt" value="Assign" Class="" style="width:60px;height:20px;font-family:Verdana, Arial, sans-serif, sans-serif;font-size:11px;font-weight:normal;border:none;color:#ffffff;" /><%--Assign</input>--%>&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Button ID="btncanceEdit" runat="server" CssClass="ItDoseButton" Text="Cancel"
                CausesValidation="false" OnClientClick="Clear()" />&nbsp;
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="mpEdit" runat="server" CancelControlID="btncanceEdit"
        DropShadow="true" TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground"
        PopupControlID="palne1" PopupDragHandleControlID="Div2">
    </cc1:ModalPopupExtender>

    <!----------------------------Modal Popup start-------------------------------------------------->
    <div id="myModal" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="height:350px;width:600px;padding:4px;">
                <div class="modal-header">
                  <button type="button" class="close" aria-hidden="true" onclick="CloseModalPopup()">&times;</button>
                  <h4 class="modal-title">View Log</h4>
                </div>
                <div class="POuter_Box_Inventory" style="width:100%;">
                    <div class="Purchaseheader">
                        View Log
                    </div>
                    <div id="divAdditionalInfo" style="overflow-x: auto;">
                        <div class="row">
                            <div class="col-md-1"></div>
                            <div class="col-md-22">
                                <div class="row">
                                    <div class="col-md-6">
                                        <label class="pull-left">
                                            Error Type
                                        </label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                        <asp:Label ID="lblViewError" runat="server"></asp:Label>
                                    </div>
                                    <div class="col-md-5">
                                        <label class="pull-left">
                                            View Date
                                        </label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-8">
                                        <asp:Label ID="lblViewDate" runat="server"></asp:Label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!----------------------------END-------------------------------------------------->

    <script type="text/javascript" src="../../Scripts/Common.js"></script>
	<script type="text/javascript" src="../../Scripts/jquery.slimscroll.js"></script>
	<script type="text/javascript" src="../../Scripts/chosen.jquery.min.js"></script>
    <script type="text/javascript">
        function tempAlert(msg, duration) {
            var el = document.createElement("div");
            el.setAttribute("style", "position:absolute;top:40%;left:44%;background-color:#3278b5;width:100px;height:30px;text-align:center;z-index:1500;line-height:25px;color:#ffffff;border-radius:8px;");
            el.innerHTML = msg;
            setTimeout(function () {
                el.parentNode.removeChild(el);
            }, duration);
            document.body.appendChild(el);
        }

        $("#btnEditt").click(function () {
            
            var en = $('[id$=ddlemployee] option:selected').text();
            var id = $('[id$=ddlemployee] option:selected').val();
          
            
            var ticket = $('[id$=hfTicketId]').text();
            if (en != "Select") {

                $.ajax({
                    url: 'AssignTicket.aspx/AssignEmployee',
                    data: '{Engineer:"' + en + '",TicketID:"' + ticket + '",enginerID:"'+id+'"}',
                    dataType: "json",
                    contentType: "application/json;charset=UTF-8",
                    async: false,
                    type: "POST",
                }).done(function (r) {
                    var stockid = $('[id$=hfStockID]').text();

                    if (stockid != "") {
                        fun_SaveBreakDown(ticket);
                    }
                });
            }
            else { alert("Select Handled By"); }
        });

        function fun_SaveBreakDown(ticktid)
        {
            var dept = $('[id$=ddlDepartment] option:selected').text();
            $.ajax({
                url: 'AssignTicket.aspx/SaveBreakDown',
                data: '{ticketID:"' + ticktid + '",department:"' + dept + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: false,
                type: "POST",
            }).done(function (r) {
                fun_SaveBreakDownDetails(ticktid);
            });
        }

        function fun_SaveBreakDownDetails(ticketID) {
            var emp = $('[id$=ddlemployee] option:selected').text();
            $.ajax({
                url: 'AssignTicket.aspx/SaveBreakDownDetails',
                data: '{employee:"' + emp + '",ticket:"' + ticketID + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: false,
                type: "POST",
            }).done(function (re) {
                alert("Saved");
                //tempAlert("Saved", 2000);
                Clear();
               // location.href.replace("AssignTicket.aspx");
                location.reload(true);
                 $('#<%=palne1.ClientID %>').hide();
                $('#dgGrid').hide();
            });
        }

        function ShowDetails(arguments, EmpID, ticket) {
            $('[id$=hfTicketId]').text(ticket);
            //$.ajax({
            //    url: 'AssignTicket.aspx/BindPopupByStatusID',
            //    data: '{stockID:"' + arguments + '"}',
            //    dataType: "json",
            //    contentType: "application/json;charset=UTF-8",
            //    async: false,
            //    type: "POST",
            //}).done(function (data) {
            //   // var r = JSON.parse(data.d);

            //    if (data.d != '') {
            //        $('[id$=lblAssetName]').text(data.d[0]);
            //        $('[id$=lblSerial]').text(data.d[2]);
            //        $('[id$=lblwarentystatus]').text(data.d[3]);
            //        $('[id$=lblWarnty]').text(data.d[4]);
            //        $('[id$=lblvendpr]').text(data.d[5]);
            //        $('[id$=lblAmcStatus]').text(data.d[6]);
            //        $('[id$=lblamcvendor]').text(data.d[7]);
            //        $('[id$=lblCMCstatus]').text(data.d[8]);
            //        $('[id$=lblCMCVendor]').text(data.d[9]);
            //        $('[id$=lblamcdate]').text(data.d[10]);
            //        $('[id$=lblWarentyNo]').text(data.d[11]);
            //        $('[id$=lblamcno]').text(data.d[12]);
            //        $('[id$=lblCMCNo]').text(data.d[13]);
            //        $('[id$=lblCMCDate]').text(data.d[14]);
            //        $('[id$=hfStockID]').text(data.d[1]);
            //    }

            //    BindEmployeeforAssign(EmpID);
            //});
            serverCall('Assignticket.aspx/BindPopupByStatusID', { stockID: arguments }, function (response) {
                var responseData = JSON.parse(response);
                $('[id$=lblAssetName]').text(responseData[0].ItemName);
                $('[id$=lblSerial]').text(responseData[0].SerialNo);
                $('[id$=lblModelNo]').text(responseData[0].ModelNo);
                $('[id$=lblAssetNo]').text(responseData[0].AssetNo);
                $('[id$=lblvendpr]').text(responseData[0].AssetNo);
                $('[id$=lblamcvendor]').text(responseData[0].AMCVendor);
                $('[id$=lblWarnty]').text(responseData[0].WarrantyToDate);
                $('[id$=lblamcdate]').text(responseData[0].AMCToDate);
             
                $('[id$=hfStockID]').text(responseData[0].AssetID);

                if (responseData[0].WarrantyStatus == '0')
                    $('[id$=lblWarnty]').css('color', 'red')+ '--(Expired)';
                else
                    $('[id$=lblWarnty]').css('color', 'green');

                if (responseData[0].AMCStatus == '0')
                    $('[id$=lblamcdate]').css('color', 'red') + '--(Expired)';
                else
                    $('[id$=lblamcdate]').css('color', 'green');

            //if()    alert(responseData);
            });
        }

        function Clear() {
            $('[id$=lblAssetName]').text("");
            $('[id$=lblSerial]').text("");
            $('[id$=lblwarentystatus]').text("");
            $('[id$=lblWarnty]').text("");
            $('[id$=lblvendpr]').text("");
            $('[id$=lblAmcStatus]').text("");
            $('[id$=lblamcvendor]').text("");
            $('[id$=lblCMCstatus]').text("");
            $('[id$=lblCMCVendor]').text("");
            $('[id$=lblamcdate]').text("");
            $('[id$=lblWarentyNo]').text("");
            $('[id$=lblamcno]').text("");
            $('[id$=lblCMCNo]').text("");
            $('[id$=lblCMCDate]').text("");
            $('[id$=hfStockID]').text("");
        }

        function BindEmployeeforAssign(employID) {
            $.ajax({
                url: 'AssignTicket.aspx/BindEmp',
                data: '{empID:"' + employID + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: false,
                type: "POST",
            }).done(function (res) {
                $('[id$=ddlemployee]').empty().append('<option selected="selected" value="0">Select</option>');
                //alert(res.d.length);
                var r = res.d;
                //var strarry = res.d.split(',');
                //alert(strarry);
                for (var i = 0; i < r.length; i++) {
                    var u = r[i];
                    var rl = r[i];
                  
                    var after = u.substring(u.indexOf('#') + 1);
                    var typ = rl.split('#');
                    var before = '';
                    if (typ.length > 1) {
                        before = typ[0];
                    }
                   // alert(before);
                    
                    $('[id$=ddlemployee]').append($("<option></option>").val(after).html(before));
                }
                //$.each(res, function (data, value) {
                //    $('[id$=ddlemployee]').append($("<option></option>").val(value).html(value));
                //});
            })
        }

        function ShowLog(ticketID) {
            $.ajax({
                url: 'AssignTicket.aspx/ShowViewLog',
                data: '{ticketID:"' + ticketID + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: false,
                type: "POST",
            }).done(function (data) {
                if (data.d != '')
                {
                    $('[id$=lblViewError]').text(data.d[0]);
                    $('[id$=lblViewDate]').text(data.d[1]);
                }

                ShowModalPopupp();
            });
        }

        function ShowModalPopupp() {
            $("#myModal").show();

            // alert(selectedvals);
        }
        function CloseModalPopup() {
            $("#myModal").hide();
        }
    </script>
</asp:Content>

