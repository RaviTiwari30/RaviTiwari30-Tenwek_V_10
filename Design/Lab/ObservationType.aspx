<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="ObservationType.aspx.cs" Inherits="Design_Lab_ObservationType" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">

        function validatespace() {
            var card = $('#<%=txtName.ClientID %>').val();
            var SearchName = $('#<%=txtSearchName.ClientID %>').val();
            if (card.charAt(0) == ' ' || card.charAt(0) == '.' || card.charAt(0) == ',') {
                $('#<%=txtName.ClientID %>').val('');
                modelAlert('First Character Cannot Be Space/Dot');
               // $('#<%=lblMsg.ClientID %>').text('First Character Cannot Be Space/Dot');
                card.replace(card.charAt(0), "");
                return false;
            }
            if (SearchName.charAt(0) == ' ' || SearchName.charAt(0) == '.' || SearchName.charAt(0) == ',') {
                $('#<%=txtSearchName.ClientID %>').val('');
                modelAlert('First Character Cannot Be Space/Dot');
               // $('#<%=lblMsg.ClientID %>').text('First Character Cannot Be Space/Dot');
                SearchName.replace(SearchName.charAt(0), "");
                return false;
            }
            else {
                // $('#<%=lblMsg.ClientID %>').text('');
                return true;
            }

        }
        function check(e) {
            var keynum
            var keychar
            var numcheck
            // For Internet Explorer  
            if (window.event) {
                keynum = e.keyCode
            }
                // For Netscape/Firefox/Opera  
            else if (e.which) {
                keynum = e.which
            }
            keychar = String.fromCharCode(keynum)
            var card = $('#<%=txtName.ClientID %>').val();
            var SearchName = $('#<%=txtSearchName.ClientID %>').val();

            if (card.charAt(0) == ' ') {
                $('#<%=txtName.ClientID %>').val('');
                modelAlert('First Character Cannot Be Space');
               // $('#<%=lblMsg.ClientID %>').text('First Character Cannot Be Space');
                return false;
            }
            if (SearchName.charAt(0) == ' ') {
                $('#<%=txtSearchName.ClientID %>').val('');
                modelAlert('First Character Cannot Be Space');
               // $('#<%=lblMsg.ClientID %>').text('First Character Cannot Be Space');
                return false;
            }

            //List of special characters you want to restrict
            if (keychar == "'" || keychar == "`" || keychar == "!" || keychar == "," || keychar == "~" || keychar == ";" || (keynum >= "40" && keynum <= "44") || (keynum >= "91" && keynum <= "95") || (keynum >= "49" && keynum <= "64") || (keynum >= "34" && keynum <= "38") || (keynum >= "123" && keynum <= "125")) {
                return false;
            }

            else {
                return true;
            }
        }
        $(document).ready(function () {
            var MaxLength = 100;
            $("#<% =txtDesc.ClientID %>").bind("cut copy paste", function (event) {
                event.preventDefault();
            });
            $("#<% =txtDesc.ClientID %>").bind("keypress", function (e) {
                // For Internet Explorer  
                if (window.event) {
                    keynum = e.keyCode
                }
                    // For Netscape/Firefox/Opera  
                else if (e.which) {
                    keynum = e.which
                }
                keychar = String.fromCharCode(keynum)
                if (e.keyCode == 39 || keychar == "'") {
                    return false;
                }

                if ($(this).val().length >= MaxLength) {

                    if (window.event)//IE
                    {
                        e.returnValue = false;
                        return false;
                    }
                    else//Firefox
                    {
                        e.preventDefault();
                        return false;
                    }

                }
            });
        });



        $(document).ready(function () {
            // $('input:text:first').focus();
            $('input:text').bind("keydown ", function (e) {
                var n = $("input:text").length;
                if (e.which == 13) {
                    e.preventDefault();
                    if ($("#<%=txtName.ClientID %>").val().length > 0) {
                        $("#<%=txtSearchName.ClientID %>").val('');
                        $("#<%=txtName.ClientID %>").focus();
                        $("#<%=btnSave.ClientID %>").click();
                    }
                    if ($("#<%=txtSearchName.ClientID %>").val().length > 0) {
                        $("#<%=txtName.ClientID %>").val('');
                        $("#<%=txtSearchName.ClientID %>").focus();
                        $("#<%=btnSearch.ClientID %>").click();
                    }

                }

            });
        });
        function validate() {

            if ($.trim($("#<%=txtName.ClientID %>").val()) == "") {
                modelAlert('Please Enter Department Name');
              //  $("#<%=lblMsg.ClientID %>").text('Please Enter Department Name');
                $("#<%=txtName.ClientID %>").focus();
                return false;
            }

            var emailaddress = $('#<%= txtEmailID.ClientID %>').val();
            var emailexp = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
            if ((emailexp.test(emailaddress) == false) && (emailaddress != "")) {
                modelAlert('Please Enter Valid Email Address');
               // $('#<%=lblMsg.ClientID %>').text('Please Enter Valid Email Address');
                $('#<%= txtEmailID.ClientID %>').focus();
                return false;
            }
        }
        $(function () {
            $("#btnReset").bind("click", function () {
                $("#txtEmailID,#txtName,#txtDesc").val('');
                $("select").not('#ctl00_ddlUserName').prop('selectedIndex', 0);
                $("#<%=chkTemplateType.ClientID%>").prop('checked', false);
            });
        });
    </script>
    <div id="Pbody_box_inventory" style="text-align: center">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory">
            <div class="row">
            <b>Create & Edit Department </b>

            </div> 
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" Visible="false"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">

            <div class="Purchaseheader">
                <div class="row"> Lab Department</div> 
            </div>
            <div class="row">
                <div class="col-md-25">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Category
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlCategory" TabIndex="1" ToolTip="Select Category" runat="server"></asp:DropDownList>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">
                                Department Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtName" ClientIDMode="Static" TabIndex="2" Width="95%" ToolTip="Enter Department Name" class="requiredField" MaxLength="50" runat="server" onkeypress="return check(event)"
                                onkeyup="validatespace();"></asp:TextBox>
                        </div>
                         <div class="col-md-2">
                            <label class="pull-left">
                                Description
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtDesc" TabIndex="3" ToolTip="Enter Description" runat="server"     Width="95%"
                                ClientIDMode="Static" MaxLength="100"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-25" style="text-align:left;">
                            <div class="col-md-7" style="text-align: right;margin-left: 22px;">
                            <asp:CheckBox ID="chkTemplateType" TabIndex="4" runat="server" CssClass="regtext" Text="Authorised to Open Templates"
                            Width="246px" />
                                </div>
                        </div>
                    </div>
                    
                    <div class="row" style="display: none;">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Department&nbsp;Logo
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:FileUpload ID="logoFIleUpload" runat="server" Width="95%" />
                            <asp:Label ID="Label1" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
            <table style="border-collapse: collapse; width: 100%;display:none;">
                <tr style="display: none">
                    <td></td>
                    <td style="text-align: right">Email ID :&nbsp;</td>
                    <td style="text-align: left">
                        <asp:TextBox ID="txtEmailID" ClientIDMode="Static" runat="server" Width="224px" MaxLength="50" CausesValidation="True"></asp:TextBox>

                    </td>
                </tr>
                <tr>
                    <td style="width: 133px; text-align: right">&nbsp;
                    </td>
                    <td style="width: 99px; text-align: right">&nbsp;
                    </td>
                    <td style="text-align: left">
                        
                    </td>
                </tr>
                <tr>
                    <td style="width: 133px; text-align: left; height: 16px;">
                        <table style="width: 62%; border-collapse: collapse">
                            <tr>
                                <td style="width: 6px">&nbsp;
                                </td>
                                <td style="width: 100px">&nbsp;
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td style="width: 99px; text-align: left;">&nbsp;
                    </td>
                    <td style="text-align: left; color: Red; width: 60%" id="divmessage"></td>
                    <td style="width: 262px; height: 16px;"></td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <asp:Button ID="btnSave" runat="server" TabIndex="5" OnClientClick="return validate();" CssClass="ItDoseButton" OnClick="btnSave_Click" Text="Save" />
            &nbsp;&nbsp;&nbsp;
                <asp:Button ID="btnClear" ClientIDMode="Static" Visible="false" runat="server" CssClass="ItDoseButton" Text="Reset" OnClick="btnClear_Click" />
            <input type="button" class="ItDoseButton" value="Reset" id="btnReset" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search
            </div>
            <div>
                <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22">
                        <div class="row">
                            <div class="col-md-6"></div>
                            <div class="col-md-4">
                                <label class="pull-left">
                                    Search By Department
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtSearchName" runat="server" MaxLength="50" onkeypress="return check(event)"
                                    onkeyup="validatespace();" ToolTip="Enter Subcategory Department Name"></asp:TextBox>
                            </div>
                            <div class="col-md-2">
                                <asp:Button ID="btnSearch" CssClass="ItDoseButton" OnClick="btnSearch_Click" runat="server" Text="Search" />
                            </div>
                            <div class="col-md-7"></div>
                        </div>
                    </div>
                    <div class="col-md-1"></div>
                </div>

                <table style="width: 100%; border-collapse: collapse">
                    <tr>
                        <td style="width: 20%; text-align: right"></td>
                        <td style="width: 30%; text-align: left"></td>
                        <td style="width: 20%; text-align: left"></td>
                        <td style="width: 30%; text-align: left"></td>
                    </tr>
                    <tr>
                        <td colspan="4" style="text-align: left">
                            <div style="height:300px;overflow:auto;">
                            <asp:GridView ID="grdObservationType" runat="server" CssClass="GridViewStyle" Width="100%" OnRowCommand="grdObservationType_RowCommand"
                                OnRowUpdating="grdObservationType_RowUpdating" OnRowEditing="grdObservationType_RowEditing"
                                OnRowCancelingEdit="grdObservationType_RowCancelingEdit" AutoGenerateColumns="False">

                                <Columns>
                                    <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="25px" ItemStyle-CssClass="GridViewItemStyle"
                                        HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                            <%# Container.DataItemIndex+1 %>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="Name" HeaderText="Name">
                                        <ItemStyle CssClass="GridViewItemStyle" Width="400px" HorizontalAlign="Center" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="400px" HorizontalAlign="Center" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Print_Sequence" HeaderText="Print Sequence">
                                        <ItemStyle CssClass="GridViewItemStyle" Width="200px" HorizontalAlign="Center" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" HorizontalAlign="Center" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Description" HeaderText="Description" Visible="false">
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    </asp:BoundField>
                                    <%-- <asp:BoundField DataField="Flag" HeaderText="Observation Type"  Visible="false">
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    </asp:BoundField>--%>
                                    <asp:TemplateField HeaderText="Authorised" HeaderStyle-HorizontalAlign="Left">
                                        <EditItemTemplate>
                                            <asp:RadioButtonList ID="rbtFlag" runat="server" CssClass="ItDoseRadiobuttonlist"
                                                RepeatColumns="2" SelectedValue='<%# Eval("Flag") %>'>
                                                <asp:ListItem Value="Yes">Yes</asp:ListItem>
                                                <asp:ListItem Value="No">No</asp:ListItem>
                                            </asp:RadioButtonList>
                                        </EditItemTemplate>
                                        <ItemTemplate>
                                            <asp:Label ID="lblFlag" Text='<%# Bind("Flag")%>' runat="server"></asp:Label>
                                        </ItemTemplate>
                                        <FooterTemplate>
                                            <asp:RadioButtonList ID="rdblNewFlag" runat="server" RepeatDirection="Horizontal">
                                                <asp:ListItem Value="3" Text="Yes" Selected="True"></asp:ListItem>
                                                <asp:ListItem Value="0" Text="No"></asp:ListItem>
                                            </asp:RadioButtonList>
                                        </FooterTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Width="140px" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                    </asp:TemplateField>
                                    <asp:BoundField ReadOnly="True" DataField="Creator_ID" HeaderText="Creator Name"
                                        Visible="false">
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    </asp:BoundField>
                                    <asp:BoundField ReadOnly="True" DataField="GroupID" HeaderText="GroupID" Visible="false">
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    </asp:BoundField>
                                    <asp:TemplateField HeaderText="Active" HeaderStyle-HorizontalAlign="Left">
                                        <EditItemTemplate>
                                            <asp:RadioButtonList ID="rbtActive" runat="server" CssClass="ItDoseRadiobuttonlist"
                                                RepeatColumns="2" SelectedValue='<%# Eval("IsActive") %>'>
                                                <asp:ListItem Value="Yes">Yes</asp:ListItem>
                                                <asp:ListItem Value="No">No</asp:ListItem>
                                            </asp:RadioButtonList>
                                        </EditItemTemplate>
                                        <ItemTemplate>
                                            <asp:Label ID="lblActive" Text='<%# Bind("IsActive")%>' runat="server"></asp:Label>
                                        </ItemTemplate>
                                        <FooterTemplate>
                                            <asp:RadioButtonList ID="rdblNewActive" runat="server" RepeatDirection="Horizontal">
                                                <asp:ListItem Value="1" Text="Yes" Selected="True"></asp:ListItem>
                                                <asp:ListItem Value="0" Text="No"></asp:ListItem>
                                            </asp:RadioButtonList>
                                        </FooterTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Width="140px" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Logo" Visible="false">
                                        <ItemTemplate>
                                            <asp:FileUpload ID="fuLogo" runat="server" />
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                    </asp:TemplateField>
                                    <asp:CommandField ShowEditButton="True" HeaderText="Edit" ButtonType="Image" EditImageUrl="~/Images/edit.png" CancelImageUrl="~/Images/Delete.gif" UpdateImageUrl="~/Images/Post.GIF">
                                        <ItemStyle CssClass="GridViewItemStyle" Width="60px"></ItemStyle>
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                                    </asp:CommandField>
                                    <asp:TemplateField Visible="false">
                                        <ItemTemplate>
                                            <asp:Label ID="lblObservationType_ID" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ObservationType_ID") %>'
                                                Visible="False"></asp:Label>
                                            <asp:Label ID="lblDesc" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"Description") %>'
                                                Visible="false"></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Remove" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" Visible="false">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="imbRemove" runat="server" ImageUrl="~/Images/Delete.gif" CausesValidation="false"
                                                CommandArgument='<%# Eval("ObservationType_ID") %>' CommandName="imbRemove" ToolTip="Click to Remove" />
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" Width="30px" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="View" Visible="false">
                                        <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                        <ItemTemplate>

                                            <asp:ImageButton ID="imbView" runat="server" CausesValidation="false" CommandName="AView"
                                                ToolTip="Click To View Available Document"
                                                ImageUrl="~/Images/view.GIF" CommandArgument='<%# Eval("ObservationType_ID")  %>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                </Columns>
                                <HeaderStyle HorizontalAlign="Left"></HeaderStyle>
                                <AlternatingRowStyle></AlternatingRowStyle>
                            </asp:GridView>
                                </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4" style="text-align: right"></td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
