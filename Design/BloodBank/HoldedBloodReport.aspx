<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="HoldedBloodReport.aspx.cs" Inherits="Design_BloodBank_HoldedBloodReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
     <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
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

        $(document).ready(function () {
            $('#txtholddatefrom').change(function () {
                ChkDate();
            });
            $('#txtholddateTo').change(function () {
                ChkDate();
            });
        });
        function ChkDate() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtholddatefrom').val() + '",DateTo:"' + $('#txtholddateTo').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblerrmsg.ClientID %>').text('To date can not be less than from date!');
                        $('#<%=btnSearch.ClientID %>').attr('disabled', 'disabled');
                        $('#<%=btnPrint.ClientID %>').attr('disabled', 'disabled');
                        $('#<%=grdStock.ClientID %>').hide();
                    }
                    else {
                        $('#<%=lblerrmsg.ClientID %>').text('');
                        $('#<%=btnSearch.ClientID %>').removeAttr('disabled');
                        $('#<%=btnPrint.ClientID %>').removeAttr('disabled');
                    }
                }
            });
        }
    </script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Hold Blood Stock Status Report</b><br />
            <asp:Label ID="lblerrmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">

            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Patient ID
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPatientID" runat="server" MaxLength="20"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                IPD No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtTransactionID" runat="server" MaxLength="10"></asp:TextBox>
                         
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Bag Number
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtTubeNo" runat="server" MaxLength="20"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Hold From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtholddatefrom" runat="server" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="caldatefrom" TargetControlID="txtholddatefrom" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Hold To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtholddateTo" runat="server" ClientIDMode="Static" ></asp:TextBox>
                            <cc1:CalendarExtender ID="caldateTo" TargetControlID="txtholddateTo" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3" style="display:none">
                            <label class="pull-left">
                                Bag Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5" style="display:none;">
                            <asp:DropDownList ID="ddlBagType" runat="server" >
                            </asp:DropDownList>
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
                        <div class="col-md-10">
                        </div>
                        <div class="col-md-4">
                            <asp:Button ID="btnSearch" Text="Search" CssClass="ItDoseButton" runat="server" OnClick="btnSearch_Click" />
                            <asp:Button ID="btnPrint" Text="Report" CssClass="ItDoseButton" runat="server" OnClick="btnPrint_Click" />
                        </div>
                        <div class="col-md-10">
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div id="pnlHide" runat="server" class="POuter_Box_Inventory" visible="false">
            <asp:GridView ID="grdStock" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="false" Width="100%">
                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                <Columns>
                    <asp:TemplateField HeaderText="S.No.">
                        <ItemTemplate>
                            <%#Container.DataItemIndex+1 %>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Centre">
                        <ItemTemplate>
                            <asp:Label ID="lblPatientID" runat="server" Text='<%# Util.GetString(Eval("CentreName"))%>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="UHID">
                        <ItemTemplate>
                            <asp:Label ID="lblPatientID" runat="server" Text='<%# Util.GetString(Eval("PatientID")).Replace("LSHHI","")%>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="IPD No">
                        <ItemTemplate>
                            <asp:Label ID="lblTransactionID" runat="server" Text='<%# Util.GetString(Eval("TransactionID")).Replace("LLSHHI","").Replace("LSHHI","").Replace("LISHHI","").Replace("ISHHI","")%>' />
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="PName">
                        <ItemTemplate>
                            <asp:Label ID="lblPName" runat="server" Text='<%#Eval("PName")%>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="90px" />
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
                            <asp:Label ID="lblBBTubeNo" runat="server" Text='<%#Eval("BBTubeNo")%>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Expiry Date">
                        <ItemTemplate>
                            <asp:Label ID="lblExpiryDate" runat="server" Text='<%#Eval("Expiry")%>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="90px" />
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>
</asp:Content>
