<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="ReSearch.aspx.cs" Inherits="Design_OPD_ReSearch" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script  src="../../Scripts/ScrollableGridPlugin.js" type="text/javascript"></script>
    <script  src="../../Scripts/Message.js" type="text/javascript"></script>
    <script type="text/javascript" >

        $(function () {
            $('#txtConfirmDateFrom').change(function () {
                ChkDate();
            });

            $('#txtConfirmdateTo').change(function () {
                ChkDate();
            });

        });

       

        function ChkDate() {

            $.ajax({

                url: "../Common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtConfirmDateFrom').val() + '",DateTo:"' + $('#txtConfirmdateTo').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#lblMsg').text('To date can not be less than from date!');
                        $('#btnConfirmSearch').attr('disabled', 'disabled');
                        $("#tbAppointment table").remove();

                    }
                    else {
                        $('#lblMsg').text('');
                        $('#btnConfirmSearch').removeAttr('disabled');
                    }
                }
            });

        }
        $(document).ready(function () {
            $('#<%=grdAppointment.ClientID %>').Scrollable();
            $('#<%=pnlPrint.ClientID %>').find(':checkbox').attr('checked', '');
            chkprint();
        });

       
        function chkprint() {
           
        }
        function pageLoad(sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                if ($find("mpResearch")) {
                    $find("mpResearch").hide();

                }
                if ($find("mpClose")) {
                    $find("mpClose").hide();
                }
            }
        }
   
    </script>
    <script type="text/javascript">
        $(document).ready(function () {


        });
    </script>
    <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" EnableScriptGlobalization="true"
        EnableScriptLocalization="true">
    </cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            
                <b>Confirm List</b>
            
            <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
            
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria</div>
            <table style=" width:100%">
                <tr>
                    <td style="text-align: right; width: 221px">
                        From Confirm Date :
                    </td>
                    <td style="text-align: left; width: 101px">
                        <asp:TextBox ID="txtConfirmDateFrom" runat="server" ToolTip="Click To Select From Confirm Date"
                            Width="129px" TabIndex="1" ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="txtConfirmDateFrom_CalendarExtender" runat="server" TargetControlID="txtConfirmDateFrom"
                            Format="dd-MMM-yyyy" ClearTime="true">
                        </cc1:CalendarExtender>
                    </td>
                    <td style="width: 172px; text-align: right">
                        To Confirm Date :
                    </td>
                    <td style="text-align: left">
                        <asp:TextBox ID="txtConfirmdateTo" runat="server" ToolTip="Click To Select To Confirm Date"
                            Width="129px" TabIndex="2" ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="txtConfirmdateTo_CalendarExtender" runat="server" TargetControlID="txtConfirmdateTo"
                            Format="dd-MMM-yyyy" ClearTime="true">
                        </cc1:CalendarExtender>
                    </td>
                </tr>
                <tr>
                    <td colspan="4" style="text-align: center">
                        <asp:Button ID="btnConfirmSearch" runat="server" Text="Search" OnClick="btnConfirmSearch_Click"
                            ClientIDMode="Static" TabIndex="3" ToolTip="Click to Search" CssClass="ItDoseButton" />
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Results</div>
            <table id="tbAppointment">
                <tr>
                    <td>
                        <asp:GridView ID="grdAppointment" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                            Width="965px" OnRowCommand="grdAppointment_RowCommand" OnRowDataBound="grdAppointment_RowDataBound">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                                <asp:TemplateField HeaderText="S.No.">
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" Width="20px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="UHID">
                                    <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" Width="100px" />
                                    <ItemStyle CssClass="GridViewItemStyle" Width="100px" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblPatientID" runat="server" Text='<%#Eval("PatientID") %>' Visible="false"></asp:Label>
                                        <asp:Label ID="lblMRNo" runat="server" Text='<%#Util.GetString(Eval("PatientID")) %>'></asp:Label>
                                        <asp:Label ID="lblLedgerTnxNo" runat="server" Text='<%#Eval("LedgerTnxNo") %>' Visible="false"></asp:Label>
                                        <asp:Label ID="lbltransactionid" runat="server" Text='<%#Eval("TransactionID") %>'
                                            Visible="false"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="AppNo" HeaderText="App. No.">
                                    <ItemStyle CssClass="GridViewItemStyle" Width="40px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="App_ID" HeaderText="AppID" Visible="false">
                                    <ItemStyle CssClass="GridViewItemStyle" Width="20px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Name" HeaderText="Patient Name">
                                    <ItemStyle CssClass="GridViewItemStyle" Width="160px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="160px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="DoctorName" HeaderText="Doctor Name">
                                    <ItemStyle CssClass="GridViewItemStyle" Width="160px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="160px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="VisitType" HeaderText="Visit Type">
                                    <ItemStyle CssClass="GridViewItemStyle" Width="100px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="AppTime" HeaderText="App. Time">
                                    <ItemStyle CssClass="GridViewItemStyle" Width="80px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="AppDate" HeaderText="App. Date">
                                    <ItemStyle CssClass="GridViewItemStyle" Width="80px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="ConformDate" HeaderText="Confirm Date">
                                    <ItemStyle CssClass="GridViewItemStyle" Width="90px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="90px" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="Print" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemStyle CssClass="GridViewItemStyle" Width="40px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblAppID" runat="server" Text='<%#Eval("App_ID") %>' Visible="false"></asp:Label>
                                        <asp:Button ID="btnPrint" runat="server" Text="Print" CssClass="ItDoseButton" ToolTip="Click to Print"
                                            CommandName="btnPrint" CommandArgument='<%#Eval("PatientID")+"#"+Eval("LedgerTnxNo")+"#"+Eval("App_ID")+"#"+Eval("TransactionID") %>' />
                                        <asp:Button ID="btnResearch" Visible="false" runat="server" Text="Research" CommandName="btnResearch"
                                            CommandArgument='<%#Eval ("App_ID") %>' CssClass="ItDoseButton"/>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </td>
                </tr>
            </table>
            <asp:Button ID="btnHidden" runat="server" Text="Button" Style="display: none" CssClass="ItDoseButton"/>
        </div>
        <asp:Panel ID="pnlPrint" runat="server" CssClass="pnlVendorItemsFilter" Width="500px"
            BorderStyle="Solid" Style="display:none">
            <div class="Purchaseheader">
                Research Form &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp;
                &nbsp; &nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Press esc or click
                <asp:ImageButton ID="imgCloseButton" runat="server" ClientIDMode="Static" ImageUrl="~/Images/Delete.gif" />
                to close</div>
            <table style=" width:100%">
                <tr>
                    <td colspan="2">
                        <asp:Label ID="lblPopupMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                        <asp:Label ID="lblAppID" runat="server" Visible="false"></asp:Label>
                        <asp:Label ID="lblPatientID" runat="server" Text="" Visible="false"></asp:Label>
                        <asp:Label ID="lblTnxID" runat="server" Visible="false" Text=""></asp:Label>
                        <asp:Label ID="lblTID" runat="server" Visible="false" Text=""></asp:Label>
                       
                    </td>
                    <td colspan="2" style="height: 8px">
                    </td>
                </tr>
                <tr>
                    <td colspan="4" style="height: 8px">
                        <asp:GridView ID="repResearch" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                            OnRowCommand="repResearch_RowCommand" OnRowDataBound="repResearch_RowDataBound">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                                <asp:TemplateField>
                                    <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                    <ItemTemplate>
                                        <asp:Button ID="btnprint1" CssClass="ItDoseButton" runat="server" Text="View" CommandName="Print" CommandArgument='<%# Eval("Islink")+"#"+Eval("Url")+"#"+Eval("ID")+"#"+Eval("Formid") %>'  ToolTip="Click To Print"/>
                                        <asp:CheckBox ID="chk" runat="server" Checked="true" Visible="false" class="chkToCompare" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Research Form">
                                    <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="400px" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblFormName" runat="server" Text='<%#Eval("Name") %>'></asp:Label>
                                        <asp:Label ID="lblFormID" runat="server" Text='<%#Eval("Formid") %>' Visible="false"></asp:Label>
                                        <asp:Label ID="lblID" runat="server" Text='<%#Eval("ID") %>' Visible="false"></asp:Label>
                                        <asp:Label ID="lblLink" runat="server" Text='<%#Eval("Islink") %>' Visible="false"></asp:Label>
                                        <asp:Label ID="lblurl" runat="server" Text='<%#Eval("Url") %>' Visible="false"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField >
                                <asp:TemplateField HeaderText="Group">
                                <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="300px" />
                                <ItemTemplate>
                                <asp:Label ID="lblGroupName" runat="server" Text='<%#Eval("formname") %>'></asp:Label>
                                </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                        &nbsp;
                    </td>
                </tr>
                <tr  style="display: none; text-align:center">
                    <td style="width: 241px; display: none; text-align:center" >
                        <asp:Button ID="btnPrint1" runat="server" CssClass="ItDoseButton" OnClick="btnPrint_Click"
                            Text="Print" ToolTip="Click to Print" />
                    </td>
                    <td style="width: 131px; text-align: center;">
                        <asp:Button ID="btnCancel" runat="server" Text="Close" CssClass="ItDoseButton" ToolTip="Click to Close" />
                    </td>
                    <td style="display: none">
                        &nbsp;
                    </td>
                    <td style="display: none">
                        &nbsp;
                    </td>
                </tr>
            </table>
        </asp:Panel>
        <cc1:ModalPopupExtender ID="mpClose" runat="server" CancelControlID="imgCloseButton" DropShadow="true"
            TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground" PopupControlID="pnlPrint"
            BehaviorID="mpClose">
        </cc1:ModalPopupExtender>
        <asp:Panel ID="pnlResearch" runat="server" CssClass="pnlVendorItemsFilter" Style="display: none"
            Width="394px" BorderStyle="Solid">
            <div class="Purchaseheader">
                Research Required &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp;
                &nbsp; &nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;Press
                esc to close</div>
            <table style=" width:100%">
                <tr>
                    <td colspan="2" style="height: 8px">
                        <asp:Label ID="lblapp_id" runat="server" Text="" Visible="false"></asp:Label>
                        <asp:Label ID="lblmsgs" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:Label>
                        <br />
                    </td>
                    <td colspan="2" style="height: 8px">
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="height: 8px">
                        <%--<asp:CheckBoxList ID="chklstRe" runat="server">
                            <asp:ListItem Value="1">SRS</asp:ListItem>
                            <asp:ListItem Value="2">ODI</asp:ListItem>
                            <asp:ListItem Value="3">HIP</asp:ListItem>
                            <asp:ListItem Value="4">KNEE</asp:ListItem>
                            <asp:ListItem Value="5">SCTR</asp:ListItem>
                            <asp:ListItem Value="6">VAS</asp:ListItem>
                        </asp:CheckBoxList>--%>
                    </td>
                    <td colspan="2" style="height: 8px">
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td style="width: 241px;" align="center">
                        
                    </td>
                    <td style="width: 131px;">
                        <asp:Button ID="btnCancel1" runat="server" Text="Close" CssClass="ItDoseButton"/>
                    </td>
                    <td style="display: none">
                        &nbsp;
                    </td>
                    <td style="display: none">
                        &nbsp;
                    </td>
                </tr>
            </table>
        </asp:Panel>
        <cc1:ModalPopupExtender ID="mpResearch" runat="server" CancelControlID="btnCancel1"
            DropShadow="true" TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground"
            PopupControlID="pnlResearch" BehaviorID="mpResearch">
        </cc1:ModalPopupExtender>
    </div>
</asp:Content>
