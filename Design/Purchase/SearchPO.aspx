<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SearchPO.aspx.cs" Inherits="Design_Purchase_SearchPO"
    MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">

    <script src="../../Scripts/Message.js" type="text/javascript"></script>
    <script type="text/javascript">


        var _oldColor;
        function SetNewColor(source) {
            _oldColor = source.style.backgroundColor;
            source.style.backgroundColor = '#cc99cc';
        }

        function SetOldColor(source) {
            source.style.backgroundColor = _oldColor;
        }
        function ShowPO(PONo) {
            var imgtoprint = "";
            var RejectItem = "";
            if (document.getElementById("<%=chkImgToPrint.ClientID %>").checked == true) {
                imgtoprint = "1";
            }
            else {
                imgtoprint = "0";
            }
            if (document.getElementById("<%=chkPrintReject.ClientID %>").checked == true) {
                RejectItem = "1";
            }
            else {
                RejectItem = "0";
            }
            window.open('POReport.aspx?PONumber=' + PONo + '&ImageToPrint=' + imgtoprint + '&RejectItem=' + RejectItem);
        }

        $(document).ready(function () {
            $('select').chosen();
            $('#EntryDate1').change(function () {
                ChkDate();
            });
            $('#EntryDate2').change(function () {
                ChkDate();
            });
        });
        function ChkDate() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#EntryDate1').val() + '",DateTo:"' + $('#EntryDate2').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        DisplayMsg('MM09', '<%=lblMsg.ClientID %>');
                        $('#<%=btnSearch.ClientID %>,#<%=btnReport.ClientID %>,#<%=btnSN.ClientID %>,#<%=btnRN.ClientID %>,#<%=btnNA.ClientID %>,#<%=btnA.ClientID %>').attr('disabled', 'disabled');


                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $('#<%=btnSN.ClientID %>,#<%=btnSearch.ClientID %>,#<%=btnReport.ClientID %>').removeAttr('disabled');
                        $('#<%=btnRN.ClientID %>,#<%=btnNA.ClientID %>,#<%=btnA.ClientID %>').removeAttr('disabled');

                    }
                }
            });

        }

    </script>
    <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
    </cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Purchase Order Search</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Order No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPONo" runat="server"
                                MaxLength="20" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Order Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="cmbRequestType" runat="server" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                               <asp:CheckBox ID="chkitem" OnCheckedChanged="chkitem_CheckedChanged" AutoPostBack="true" runat="server" /> Item Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="lstItem" runat="server" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Item Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlItemType" runat="server">
                                <asp:ListItem Selected="True" Text="All" Value="2" />
                                <asp:ListItem Text="Non-Free" Value="0" />
                                <asp:ListItem Text="Free" Value="1" />
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Supplier Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="lstVendor" runat="server" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Status
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="cmbStatus" runat="server" Width="">
                                <asp:ListItem Value="5">All</asp:ListItem>
                                <asp:ListItem Value="0">Pending Approval</asp:ListItem>
                                <asp:ListItem Value="2">Approved</asp:ListItem>
                                <asp:ListItem Value="1">Rejected</asp:ListItem>                               
                                <asp:ListItem Value="3">GRN Done</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Store Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="cmbPurchase" runat="server" TabIndex="5" ToolTip="Select Store" AutoPostBack="true" OnSelectedIndexChanged="cmbPurchase_SelectedIndexChanged" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="EntryDate1" runat="server" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="calFromDate" runat="server" Format="dd-MMM-yyyy" TargetControlID="EntryDate1">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="EntryDate2" runat="server" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" Format="dd-MMM-yyyy"
                                TargetControlID="EntryDate2">
                            </cc1:CalendarExtender>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                              Category
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlCategory" runat="server"></asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-10"></div>
                        <div class="col-md-2">
                            <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" Text="Search"
                                OnClick="btnSearch_Click" />
                        </div>
                        <div class="col-md-3">
                            <asp:Button ID="btnReport" runat="server" Text="Report" CssClass="ItDoseButton" />
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
            <table style="width: 100%; border-collapse: collapse">
                <tr style="display: none;">
                    <td style="width: 24%">
                        <asp:CheckBox ID="chkAutoPo" runat="server" Text="AutoPoOnly" />&nbsp;
                    </td>
                    <td style="width: 10%; text-align: right;">Subject :
                    </td>
                    <td colspan="2">
                        <asp:TextBox ID="txtSubject" runat="server" Width="320px" />&nbsp;
                    </td>
                    <td style="text-align: left">
                        <asp:CheckBox ID="chkImgToPrint" Checked="true" runat="server" Text="Print" />
                        <asp:CheckBox ID="chkPrintReject" Checked="false" runat="server" Text="Print Rejected Items" />
                    </td>
                </tr>
                <tr>
                    <td style="width: 24%">&nbsp;
                    </td>
                    <td colspan="2">&nbsp;
                    </td>
                    <td>&nbsp;
                    </td>
                    <td>&nbsp;
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">

                    <div class="row">
                        <div class="col-md-7"></div>
                         <div class="col-md-5">
                            <asp:Button ID="btnA" runat="server" Width="30px" Height="25px" BackColor="LightBlue"
                                CssClass="ItDoseButton11 circle" ToolTip="Click for Partial Purchase Order" OnClick="btnA_Click" Style="cursor: pointer;" />
                            <b style="margin-top: 5px; margin-left: 5px;">Pending Approval</b>
                        </div>
                        <div class="col-md-3">
                            <asp:Button ID="btnSN" runat="server" Width="25px" Height="25px" BackColor="yellowgreen"
                                CssClass="ItDoseButton11 circle" ToolTip="Click for Open Purchase Order" OnClick="btnSN_Click" Style="cursor: pointer;" />
                            <b style="margin-top: 5px; margin-left: 5px;">Approved</b>
                        </div>
                         <div class="col-md-3">
                            <asp:Button ID="btnNA" runat="server" Width="25px" Height="25px" BackColor="LightPink"
                                CssClass="ItDoseButton11 circle" ToolTip="Click for Reject Purchase Order" OnClick="btnNA_Click" Style="cursor: pointer;" />
                            <b style="margin-top: 5px; margin-left: 5px;">Rejected</b>
                        </div> 
                        <div class="col-md-3">
                            <asp:Button ID="btnRN" runat="server" Width="25px" Height="25px" BackColor="yellow"
                                CssClass="ItDoseButton11 circle" ToolTip="Click for Close Purchase Order" OnClick="btnRN_Click" Style="cursor: pointer;" />
                            <b style="margin-top: 5px; margin-left: 5px;">GRN Done</b>
                        </div>                                             
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Result
            </div>
            <div style="text-align: center;">
                <asp:Panel ID="pnlgv" runat="server" Height="350px" ScrollBars="Vertical">
                    <asp:GridView ID="GridView1" runat="server" Width="100%" AutoGenerateColumns="False" CssClass="GridViewStyle"
                        OnRowDataBound="GridView1_RowDataBound" ToolTip="Please Double click for Order Details">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:TemplateField HeaderText="S.No.">
                                <ItemTemplate>
                                    <%#Container.DataItemIndex+1 %>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                            </asp:TemplateField>
                            <asp:BoundField DataField="PurchaseOrderNo" HeaderText="PO No.">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="146px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Subject" HeaderText="Narration">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="280px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="GrossTotal" HeaderText="Total Cost">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Type" HeaderText="Type">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="65px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Status" HeaderText="Status">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="65px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="RaisedDate" HeaderText="Raised Date">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="VendorName" HeaderText="Supplier">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="340px" />
                            </asp:BoundField>
                        </Columns>
                    </asp:GridView>
                </asp:Panel>
            </div>
        </div>
    </div>
    <asp:Panel ID="Panel1" runat="server" CssClass="pnlItemsFilter" Style="display: none;"
        Width="304px">
        <div class="Purchaseheader" id="Div1" runat="server">
            Select Report Type
        </div>
        <div class="content">
            <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <asp:Panel ID="Panel2" runat="server">
                        <asp:RadioButtonList ID="rdoMedical_general" runat="server" RepeatDirection="Horizontal"
                            CssClass="ItDoseRadiobuttonlist" Width="232px">
                            <asp:ListItem Selected="True" Text="Medical Store" Value="STO00001" />
                            <asp:ListItem Text="General Store" Value="STO00002" />
                        </asp:RadioButtonList>
                        <br />
                        <asp:RadioButtonList ID="rdoReportType" runat="server" RepeatDirection="Horizontal"
                            CssClass="ItDoseRadiobuttonlist" AutoPostBack="True" OnSelectedIndexChanged="rdoReportType_SelectedIndexChanged">
                            <asp:ListItem Selected="True" Text="Summary" Value="1" />
                            <asp:ListItem Text="Detail" Value="2" />
                        </asp:RadioButtonList>
                        <asp:RadioButtonList ID="rbtPDF" runat="server" RepeatDirection="Horizontal" CssClass="ItDoseRadiobuttonlist"
                            Visible="False">
                            <asp:ListItem Selected="True" Text="PDF" Value="1" />
                            <asp:ListItem Text="Excel" Value="2" />
                        </asp:RadioButtonList>
                    </asp:Panel>
                </ContentTemplate>
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="rdoReportType" EventName="SelectedIndexChanged"></asp:AsyncPostBackTrigger>
                </Triggers>
            </asp:UpdatePanel>
        </div>
        <div class="filterOpDiv">
            <asp:Button ID="btnReportDetail" runat="server" CssClass="ItDoseButton" Text="Report"
                OnClick="btnReportDetail_Click" />&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Button ID="btnItemCancel" runat="server" CssClass="ItDoseButton" Text="Cancel" />
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="mpeCreateGroup" runat="server" CancelControlID="btnItemCancel"
        DropShadow="true" TargetControlID="btnReport" BackgroundCssClass="filterPupupBackground"
        PopupControlID="Panel1" PopupDragHandleControlID="dragHandle">
    </cc1:ModalPopupExtender>
</asp:Content>
