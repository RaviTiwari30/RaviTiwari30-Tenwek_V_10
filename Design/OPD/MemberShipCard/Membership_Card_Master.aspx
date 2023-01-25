<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="Membership_Card_Master.aspx.cs" Inherits="Design_OPD_MemberShipCard_Membership_Card_Master" Title="Untitled Page" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        function validate(e) {
            e.preventDefault();
            var txtCardName = $('[id^=txtCardName]');
            var txtDescription = $('[id^=txtDescription]')
            if (String.isNullOrEmpty(txtCardName.val())) {
                modelAlert('Please Enter Card Name', function () {
                    txtCardName.focus();
                });
                return false;
            }
            if (String.isNullOrEmpty(txtDescription.val())) {
                modelAlert('Please Enter Card Description', function () {
                    txtDescription.focus();
                });
                return false;
            }
            __doPostBack('ctl00$ContentPlaceHolder1$btnSave', true);
           
        }
    </script>




    <Ajax:ScriptManager ID="sm" runat="server" />
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Membership Card Master</b>
            <br />
            <asp:Label ID="lblmsg" runat="server" Font-Bold="True" Font-Size="9pt" ForeColor="Red"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Membership Card Details
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Card Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtCardName" ClientIDMode="Static" CssClass="requiredField" runat="server" Width=""></asp:TextBox>
                           <%-- <asp:RequiredFieldValidator ID="RequiredFieldValidator1"  runat="server" ControlToValidate="txtCardName"
                              ForeColor="Red"   ErrorMessage="Please Enter Card Name" SetFocusOnError="True" ValidationGroup="save"></asp:RequiredFieldValidator>--%>
                        </div>
                         <div class="col-md-3">
                            <label class="pull-left">
                                Valid (YRS)
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlValidYrs" ClientIDMode="Static" runat="server">
                                <asp:ListItem>1</asp:ListItem>
                                <asp:ListItem>2</asp:ListItem>
                                <asp:ListItem>3</asp:ListItem>
                                <asp:ListItem>4</asp:ListItem>
                                <asp:ListItem>5</asp:ListItem>
                                <asp:ListItem>6</asp:ListItem>
                                <asp:ListItem>7</asp:ListItem>
                                <asp:ListItem>8</asp:ListItem>
                                <asp:ListItem>9</asp:ListItem>
                                <asp:ListItem>10</asp:ListItem>
                                <asp:ListItem>11</asp:ListItem>
                                <asp:ListItem>12</asp:ListItem>
                                <asp:ListItem>13</asp:ListItem>
                                <asp:ListItem>14</asp:ListItem>
                                <asp:ListItem>15</asp:ListItem>
                                <asp:ListItem>16</asp:ListItem>
                                <asp:ListItem>17</asp:ListItem>
                                <asp:ListItem>18</asp:ListItem>
                                <asp:ListItem>19</asp:ListItem>
                                <asp:ListItem>20</asp:ListItem>
                            </asp:DropDownList>
                        </div>

                       <%-- <div class="col-md-3">
                            <label class="pull-left">
                                Card Amount
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtCardAmount" CssClass="requiredField" Width="" runat="server"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ForeColor="Red" ControlToValidate="txtCardAmount" ErrorMessage="Please Enter Card Amount" SetFocusOnError="True" ValidationGroup="save"></asp:RequiredFieldValidator>
                            <cc1:FilteredTextBoxExtender ID="fc1" runat="server" ValidChars="." TargetControlID="txtCardAmount" FilterMode="ValidChars" FilterType="Numbers,Custom"></cc1:FilteredTextBoxExtender>
                        </div>--%>
                        <div class="col-md-3">
                            <label class="pull-left">
                                No. of Dependant
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlDependant" ClientIDMode="Static" runat="server">
                                <asp:ListItem>1</asp:ListItem>
                                <asp:ListItem>2</asp:ListItem>
                                <asp:ListItem>3</asp:ListItem>
                                <asp:ListItem>4</asp:ListItem>
                                <asp:ListItem>5</asp:ListItem>
                                <asp:ListItem>6</asp:ListItem>
                                <asp:ListItem>7</asp:ListItem>
                                <asp:ListItem>8</asp:ListItem>
                                <asp:ListItem>9</asp:ListItem>
                                <asp:ListItem>10</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                       
                        <div class="col-md-3">
                            <label class="pull-left">
                                Description
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-13">
                            <asp:TextBox ID="txtDescription" ClientIDMode="Static" CssClass="requiredField" runat="server" Style="height: 58px; width: 100%; max-width: 100%; min-width: 100%;" TextMode="MultiLine"></asp:TextBox>
                            <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ForeColor="Red" EnableClientScript="true" ControlToValidate="txtDescription" ErrorMessage="Please Enter Description" SetFocusOnError="True" ValidationGroup="save"></asp:RequiredFieldValidator>--%>
                        </div>


                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="btnSave" runat="server" Text="Save" ClientIDMode="Static" CssClass="save margin-top-on-btn"   OnClick="btnSave_Click" ValidationGroup="save" OnClientClick="return validate(event);" />
            <asp:Button ID="btnUpdate" runat="server" Text="Update" CssClass="save margin-top-on-btn" OnClick="btnUpdate_Click" Visible="False" />
            <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="save margin-top-on-btn"  OnClick="btnCancel_Click" Visible="False" />
            <asp:Label runat="server" style="display:none" ID="lblItemID"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                All Membership Cards
            </div>
            <asp:GridView ID="MembershipCardGrid" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                OnRowCommand="EmpGrid_RowCommand" Width="100%">
                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                <Columns>
                    <asp:TemplateField HeaderText="S.No.">
                        <ItemTemplate>
                            <%# Container.DataItemIndex+1 %>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                    </asp:TemplateField>

                    <asp:BoundField DataField="Name" HeaderText="Name" ReadOnly="true">
                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="140px" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Description" HeaderText="Description" ReadOnly="true">
                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="250px" />
                    </asp:BoundField>
                    <asp:BoundField DataField="No_of_dependant" HeaderText="No.Of dependant" ReadOnly="true">
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Amount" Visible="false" HeaderText="Amount" ReadOnly="true">
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                    </asp:BoundField>
                    <asp:TemplateField HeaderText="Select">
                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                        <ItemTemplate>
                            <asp:ImageButton ID="imbSelect" runat="server" CausesValidation="false" CommandArgument='<%# Eval("ID")%>'
                                CommandName="Select" ImageUrl="~/Images/Post.gif" ToolTip="Select" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>
</asp:Content>

