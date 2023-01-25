<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="DiscardedBloodReport.aspx.cs" Inherits="Design_BloodBank_DiscardedBloodReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $('#<%=txtdiscardedfrom.ClientID %>').change(function () {
                ChkDate();
            });
            $('#<%=txtdiscardedTo.ClientID %>').change(function () {
                ChkDate();
            });
        });
        function checkAllCentre() {
            var status = $('#<%= chkAllCentre.ClientID %>').is(':checked');

            if (status == true) {
                $('.chkAllCentreCheck input[type=checkbox]').attr("checked", "checked");
            }
            else {
                $(".chkAllCentreCheck input[type=checkbox]").attr("checked", false);
            }
        }
        function chkCentreCon() {
            if (($('#<%= chkCentre.ClientID %>  input[type=checkbox]:checked').length) == ($('#<%= chkCentre.ClientID %>  input[type=checkbox]').length)) {
                $('#<%= chkAllCentre.ClientID %>').attr("checked", "checked");
            }
            else {
                $('#<%= chkAllCentre.ClientID %>').attr("checked", false);
            }
        }
        function ChkDate() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#<%=txtdiscardedfrom.ClientID %>').val() + '",DateTo:"' + $('#<%=txtdiscardedTo.ClientID %>').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblerrmsg.ClientID %>').text('To date can not be less than from date!');
                        $('#<%=btnSearch.ClientID %>,#<%=btnPrint.ClientID %>').prop('disabled', 'disabled');
                        $('#<%=grdDonorList.ClientID %>').hide();
                    }
                    else {
                        $('#<%=lblerrmsg.ClientID %>').text('');
                        $('#<%=btnSearch.ClientID %>,#<%=btnPrint.ClientID %>').removeProp('disabled');
                    }
                }
            });
        }
    </script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Discarded Blood Report</b><br />
            <asp:Label ID="lblerrmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Disc. From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtdiscardedfrom" runat="server" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="caldiscardedfrom" TargetControlID="txtdiscardedfrom" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Disc. To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtdiscardedTo" runat="server" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="caldiscardedTo" TargetControlID="txtdiscardedTo" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                        </div>
                     <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:CheckBox ID="chkAllCentre" ClientIDMode="Static" runat="server" onclick="checkAllCentre();" Text="Centre " />
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-21">
                            <asp:CheckBoxList ID="chkCentre" onclick="chkCentreCon()" RepeatColumns="7" ClientIDMode="Static" RepeatLayout="Table" CssClass="chkAllCentreCheck ItDoseCheckboxlist" runat="server" RepeatDirection="Horizontal" Height="16px">
                            </asp:CheckBoxList>
                            </div>
                          </div>
                    <div class="row">
                        <div class="col-md-24" style="text-align:center;">
                            <asp:Button ID="btnSearch" Text="Search" CssClass="ItDoseButton" runat="server" OnClick="btnSearch_Click" />
                            <asp:Button ID="btnPrint" Text="Report" CssClass="ItDoseButton" runat="server" OnClick="btnPrint_Click" />
                        </div>
                    </div>
            </div>
        </div>
        <div id="pnlHide" runat="server" visible="false" class="POuter_Box_Inventory">
            <asp:GridView ID="grdDonorList" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="false" Width="100%"
                AllowPaging="true" PageSize="10">
                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                <Columns>
                    <asp:TemplateField HeaderText="S.No.">
                        <ItemTemplate>
                            <%#Container.DataItemIndex+1 %>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Centre Name">
                        <ItemTemplate>
                            <asp:Label ID="lblCentre" runat="server" Text='<%#Eval("CentreName")%>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Stock ID" Visible="false">
                        <ItemTemplate>
                            <asp:Label ID="lblStockid" runat="server" Text='<%# Eval("Stock_id") %>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" Height="20px" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" Height="20px" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Collection ID">
                        <ItemTemplate>
                            <asp:Label ID="lblBloodCollectionID" runat="server" Text='<%#Eval("BloodCollection_ID")%>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Component Name">
                        <ItemTemplate>
                            <asp:Label ID="lblComponentName" runat="server" Text='<%#Eval("ComponentName")%>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="160px" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Bag Type" Visible="false">
                        <ItemTemplate>
                            <asp:Label ID="lblBagType" runat="server" Text='<%#Eval("BagType")%>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Bag Number">
                        <ItemTemplate>
                            <asp:Label ID="lblTubeNo" runat="server" Text='<%#Eval("bbTubeNo")%>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="90px" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Discarded By">
                        <ItemTemplate>
                            <asp:Label ID="lblName" runat="server" Text='<%#Eval("Name")%>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="90px" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Reason">
                        <ItemTemplate>
                            <asp:Label ID="lblReason" runat="server" Text='<%#Eval("Reason")%>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>
</asp:Content>
