<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="TTDApprovalReport.aspx.cs" Inherits="Design_BloodBank_TTDApprovalReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script src="../../Scripts/Message.js" type="text/javascript" ></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $('#txtdatefrom').change(function () {
                ChkDate();
            });
            $('#txtdateTo').change(function () {
                ChkDate();
            });
        });
        function ChkDate() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtdatefrom').val() + '",DateTo:"' + $('#txtdateTo').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblerrmsg.ClientID %>').text('To date can not be less than from date!');
                        $('#<%=btnSearch.ClientID %>,#<%=btnPrint.ClientID %>').prop('disabled', 'disabled');
                        $('#<%=grdTTDRecord.ClientID %>').hide();
                    }
                    else {
                        $('#<%=lblerrmsg.ClientID %>').text('');
                        $('#<%=btnSearch.ClientID %>,#<%=btnPrint.ClientID %>').removeProp('disabled');
                    }
                }
            });
        }
    </script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server"></Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>TTD Approval Report</b><br />
            <asp:Label ID="lblerrmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">

            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Collection ID
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtCollectionID" runat="server" MaxLength="20"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="ftbCollection" runat="server" FilterType="Numbers,LowercaseLetters,UppercaseLetters" TargetControlID="txtCollectionID"></cc1:FilteredTextBoxExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Method
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlMethod" runat="server">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Result
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlResult" runat="server">
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtdatefrom" runat="server" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="caldatefrom"
                                TargetControlID="txtdatefrom" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtdateTo" runat="server" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="caldateTo"
                                TargetControlID="txtdateTo" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            </label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-5">
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
        <div class="POuter_Box_Inventory" id="pnlhide" runat="server" visible="false">
            <asp:GridView ID="grdTTDRecord" runat="server" AutoGenerateColumns="false" CssClass="GridViewStyle" Style="width: 100%">
                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                <Columns>
                    <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="25px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                        <ItemTemplate>
                            <%#Container.DataItemIndex+1 %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Collection ID" HeaderStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                        <ItemTemplate>
                            <asp:Label ID="lblCollectionId" runat="server" Text='<%# Eval("BloodCollection_Id") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Test Name" HeaderStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                        <ItemTemplate>
                            <asp:Label ID="lblTest" runat="server" Text='<%# Eval("TestName") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Method" HeaderStyle-Width="80px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                        <ItemTemplate>
                            <asp:Label ID="lblMethod" runat="server" Text='<%# Eval("Method") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Value" HeaderStyle-Width="80px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                        <ItemTemplate>
                            <asp:Label ID="lblValue" runat="server" Text='<%# Eval("Value") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Result" HeaderStyle-Width="85px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                        <ItemTemplate>
                            <asp:Label ID="lblResult" runat="server" Text='<%#Eval("Result")%>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Collected Date" HeaderStyle-Width="120px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                        <ItemTemplate>
                            <asp:Label ID="lblDoc1" runat="server" Text='<%# Eval("CollectedDate") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Collected By" HeaderStyle-Width="90px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                        <ItemTemplate>
                            <asp:Label ID="lblTechnicain" runat="server" Text='<%# Eval("CollectedBy") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Approval Date" HeaderStyle-Width="120px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                        <ItemTemplate>
                            <asp:Label ID="lblApproveDate" runat="server" Text='<%# Eval("ApprovedDate") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Approved By" HeaderStyle-Width="90px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                        <ItemTemplate>
                            <asp:Label ID="lblMO" runat="server" Text='<%# Eval("ApprovedBy") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>
</asp:Content>

