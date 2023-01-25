<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="BlackList.aspx.cs" Inherits="Design_OPD_BlackList" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <script type="text/javascript">
        $(function () {
            chkType();
            //$('input[type=text]').keyup(function () {
            //    if (event.keyCode == 13)
            //        $('#btnView').click();
            //});
        });
        function chkType() {


            var rblValue = $('#<%=rblCon.ClientID %> input[type=radio]:checked').val();
            if (rblValue == "1") {
                $("#txtReceiptNum").val('').attr('disabled', 'disabled');
                $("#txtBillNumber").val('').removeAttr('disabled');
            }
            else {
                $("#txtReceiptNum").val('').removeAttr('disabled');
                $("#txtBillNumber").val('').attr('disabled', 'disabled');
            }
        }
    </script>
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" EnablePageMethods="true" runat="server"
            EnableScriptGlobalization="true" EnableScriptLocalization="true">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>BlackList</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
            <table style="text-align: center; width: 100%;">
                <tr>
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    </td>
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    </td>
                    <td>


                        <asp:RadioButtonList ID="rblCon"  runat="server" RepeatColumns="2" OnSelectedIndexChanged="btnView_Click" AutoPostBack="true" RepeatDirection="Horizontal" onclick="chkType()">
                            <asp:ListItem Text="Bill"  Value="1" Selected="True"></asp:ListItem>
                            <asp:ListItem Text="Receipt" Value="2"></asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory">
             <div class="Purchaseheader">
                Search Criteria&nbsp;
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                UHID
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtUHID" AutoCompleteType="Disabled" runat="server" ClientIDMode="Static" TabIndex="1" ToolTip="Enter UHID"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Patient Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                         <div class="col-md-5">
                            <asp:TextBox ID="txtPName" AutoCompleteType="Disabled" runat="server" ClientIDMode="Static" TabIndex="1" ToolTip="Enter Patient Name"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                IPD No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtIPDNumber" AutoCompleteType="Disabled" runat="server" ClientIDMode="Static" TabIndex="1" ToolTip="Enter IPD No."></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Receipt No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtReceiptNum" AutoCompleteType="Disabled" runat="server" ClientIDMode="Static" TabIndex="1" ToolTip="Enter Receipt No."></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Bill No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtBillNumber" AutoCompleteType="Disabled" runat="server" ClientIDMode="Static" TabIndex="1" ToolTip="Enter Bill No."></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Contact No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtContactNumber" AutoCompleteType="Disabled" runat="server" ClientIDMode="Static" TabIndex="1" ToolTip="Enter Contact No."></asp:TextBox>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" TabIndex="7" Text="Search" OnClick="btnSearch_Click" ClientIDMode="Static" ToolTip="Click to search" />

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Patient Details Found
            </div>
            <div style="overflow: auto; padding: 3px; height: 250px;">
                <asp:GridView ID="dgGrid" runat="server" AutoGenerateColumns="false" Width="100%" CssClass="GridViewStyle" 
                    OnRowCommand="dgGrid_RowCommand" OnRowDataBound="dgGrid_RowDataBound" OnRowEditing="dgGrid_RowEditing">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:CheckBox ID="chkSelect" class="chkSelect" runat="server" Enabled='<%# Util.GetBoolean(Eval("Save")) %>'  />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" Width="20px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%#Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="UHID">
                            <ItemTemplate>
                                <asp:Label ID="lblUHID" runat="server" Text='<%#Eval("PatientID") %>'></asp:Label>
                                 <asp:Label ID="lblBlackListID" runat="server" Visible="false" Text='<%#Eval("ID") %>'></asp:Label>
                            </ItemTemplate>
                             <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Patient Name">
                            <ItemTemplate>
                                <asp:Label ID="lblPname" runat="server" Text='<%#Eval("Pname") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Gender">
                            <ItemTemplate>
                                <asp:Label ID="lblGender" runat="server" Text='<%#Eval("Gender") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                        </asp:TemplateField>
                         <asp:TemplateField HeaderText="Age">
                            <ItemTemplate>
                                <asp:Label ID="lblAge" runat="server" Text='<%#Eval("Age") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                        </asp:TemplateField>
                         <asp:TemplateField HeaderText="Mobile">
                            <ItemTemplate>
                                <asp:Label ID="lblMobile" runat="server" Text='<%#Eval("Mobile") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Address">
                            <ItemTemplate>
                                <asp:Label ID="lblAddress" runat="server" Text='<%#Eval("House_No") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                        </asp:TemplateField>

                        
                          <asp:TemplateField HeaderText="Actual Start Date">
                            <ItemTemplate>
                                <asp:Label ID="lblActualStartDate" runat="server" Text='<%#Eval("ActualStartDate") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                        </asp:TemplateField>
                             <asp:TemplateField HeaderText="Updated Start Date">
                            <ItemTemplate>
                                <asp:Label ID="lblStartDate" runat="server" Text='<%#Eval("StartDate") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                        </asp:TemplateField>
                             <asp:TemplateField HeaderText="Reason">
                            <ItemTemplate>
                                <asp:Label ID="lblReason" runat="server" Text='<%#Eval("Reason") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Edit">
                            <ItemTemplate>
                                <asp:Button ID="imBtn" runat="server" CausesValidation="false" CommandName="Edit"
                                      CommandArgument='<%# Eval("ID") %>' Visible='<%# !Util.GetBoolean(Eval("Save")) %>' Text="Edit" />
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                        </asp:TemplateField>
                         <asp:TemplateField HeaderText="Remove From BlackList">
                            <ItemTemplate>
                                <asp:Button ID="imBtnR" runat="server" CausesValidation="false" CommandName="Remove"
                                      CommandArgument='<%# Eval("ID") %>'  Visible='<%# !Util.GetBoolean(Eval("Save")) %>' Text="Remove" />
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>

        <div class="POuter_Box_Inventory">
            <div class="col-md-3">
                <label class="pull-left">
                    Start Date
                </label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-3">
                <asp:TextBox ID="ucFromDate" runat="server" ToolTip="Click To Select From Date"
                    ClientIDMode="Static" TabIndex="5"></asp:TextBox>
                <cc1:CalendarExtender ID="fc1" runat="server" TargetControlID="ucFromDate" Format="dd-MMM-yyyy">
                </cc1:CalendarExtender>
            </div>
             <div class="col-md-3">
                <label class="pull-left">
                    Reason
                </label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-15">
                <asp:TextBox ID="txtReason" runat="server" MaxLength="100"></asp:TextBox>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <center>
            <asp:Button ID="btnSave" runat="server" CssClass="ItDoseButton" Visible="false" Text="Save" OnClick="btnSave_Click" />&nbsp;
                <asp:Button ID="btnUpdate" runat="server" CssClass="ItDoseButton" Text="Update" Visible="false" OnClick="btnUpdate_Click" />
                </center>
        </div>
    </div>
</asp:Content>

