<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="Membership_Card_Discount.aspx.cs" Inherits="Design_OPD_MemberShipCard_Membership_Card_Master" Title="Untitled Page" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript">

        function SelectAllCheckboxes(chk, chkBoxName) {
            if (chkBoxName == "rbtnIsPerOPD") {
                $('#<%=grdSetDiscount.ClientID %>').find($('input:radio[name$="' + chkBoxName + '"]')).each(function () {
                    if (chk.checked == true)
                        $("input[value='OA']").attr("checked", "checked");
                    else
                        $("input[value='OP']").attr("checked", "checked");
                });
            }
            else if (chkBoxName == "rbtnIsPerIPD") {
                $('#<%=grdSetDiscount.ClientID %>').find($('input:radio[name$="' + chkBoxName + '"]')).each(function () {
            if (chk.checked == true)
                $("input[value='IA']").attr("checked", "checked");
            else
                $("input[value='IP']").attr("checked", "checked");
        });
    }
    else if (chkBoxName == "chkSelect") {
        $('#<%=grdSetDiscount.ClientID %>').find($('input:checkbox[name$="' + chkBoxName + '"]')).each(function () {
                if (this != chk) {
                    this.checked = chk.checked;
                }
            });
        }
}

function SelectAllCheckboxesItems(chk, chkBoxName) {
    if (chkBoxName == "rbtnIsPerOPD") {
        $('#<%=grdItems.ClientID %>').find($('input:radio[name$="' + chkBoxName + '"]')).each(function () {
            if (chk.checked == true)
                $("input[value='OA']").attr("checked", "checked");
            else
                $("input[value='OP']").attr("checked", "checked");
        });
    }
    else if (chkBoxName == "rbtnIsPerIPD") {
        $('#<%=grdItems.ClientID %>').find($('input:radio[name$="' + chkBoxName + '"]')).each(function () {
            if (chk.checked == true)
                $("input[value='IA']").attr("checked", "checked");
            else
                $("input[value='IP']").attr("checked", "checked");
        });
    }
    else if (chkBoxName == "chkSelect") {
        $('#<%=grdItems.ClientID %>').find($('input:checkbox[name$="' + chkBoxName + '"]')).each(function () {
                if (this != chk) {
                    this.checked = chk.checked;
                }
            });
        }
}

function MoveUpAndDownText(textbox2, listbox2) {

    var f = document.theSource;
    var listbox = listbox2;
    var textbox = textbox2;
    if (event.keyCode == 13) {
        ///__doPostBack('ListBox1','')
        textbox.value = "";
    }
    if (event.keyCode == '38' || event.keyCode == '40') {
        if (event.keyCode == '40') {
            for (var m = 0; m < listbox.length; m++) {
                if (listbox.options[m].selected == true) {
                    if (m + 1 == listbox.length) {
                        return;
                    }
                    listbox.options[m + 1].selected = true;
                    textbox.value = listbox.options[m + 1].text;

                    return;
                }
            }

            listbox.options[0].selected = true;
        }
        if (event.keyCode == '38') {
            for (var m = 0; m < listbox.length; m++) {
                if (listbox.options[m].selected == true) {
                    if (m == 0) {
                        return;
                    }
                    listbox.options[m - 1].selected = true;
                    textbox.value = listbox.options[m - 1].text;
                    return;
                }
            }

            //listbox.options[0].selected=true;
        }

    }
}

function MoveUpAndDownValue(textbox2, listbox2) {
    var f = document.theSource;
    var listbox = listbox2;
    var textbox = textbox2;
    if (event.keyCode == '38' || event.keyCode == '40') {
        if (event.keyCode == '40') {
            for (var m = 0; m < listbox.length; m++) {
                if (listbox.options[m].selected == true) {
                    if (m + 1 == listbox.length) {
                        return;
                    }
                    listbox.options[m + 1].selected = true;
                    textbox.value = listbox.options[m + 1].text;

                    return;
                }
            }

            listbox.options[0].selected = true;
        }
        if (event.keyCode == '38') {
            for (var m = 0; m < listbox.length; m++) {
                if (listbox.options[m].selected == true) {
                    if (m == 0) {
                        return;
                    }
                    listbox.options[m - 1].selected = true;
                    textbox.value = listbox.options[m - 1].text;
                    return;
                }
            }

            //listbox.options[0].selected=true;
        }

    }
}

function suggestName(textbox2, listbox2, level) {
    if (isNaN(level)) { level = 1 }
    if (event.keyCode != 38 && event.keyCode != 40 && event.keyCode != 13 && event.keyCode != 8) {
        //alert(textbox2.value);
        //var f = document.theSource;
        //var listbox = f.measureIndx;
        //var textbox = f.measure_name;
        var listbox = listbox2;
        var textbox = textbox2;

        var soFar = textbox.value.toString();
        var soFarLeft = soFar.substring(0, level).toLowerCase();
        var matched = false;
        var suggestion = '';
        var m;
        //alert(listbox.selectedIndex);
        //int len = eval(listbox.selectedIndex);
        //alert(len);
        for (m = 0; m < listbox.length; m++) {
            suggestion = listbox.options[m].text.toString();
            suggestion = suggestion.substring(0, level).toLowerCase();
            if (soFarLeft == suggestion) {
                listbox.options[m].selected = true;
                matched = true;
                break;
            }

        }
        if (matched && level < soFar.length) { level++; suggestName(textbox, listbox, level) }
    }

}


    </script>
    <Ajax:ScriptManager ID="sm" runat="server" />

    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Membership Card Discount</b>
            <br />
            <asp:Label ID="lblmsg" runat="server" Font-Bold="True" Font-Size="9pt" ForeColor="Red"></asp:Label></span>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Membership Card Discount Details
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
                            <asp:DropDownList ID="ddlCard" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlCard_SelectedIndexChanged"></asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Category Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlConfig" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlConfig_SelectedIndexChanged"></asp:DropDownList>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">
                                Free OPD Packages
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:RadioButtonList runat="server" ID="rblIsOPDPackage" RepeatDirection="Horizontal" ClientIDMode="Static">
                                <asp:ListItem Value="Yes">
                                    Yes
                                </asp:ListItem>
                                <asp:ListItem Value="No" Selected="True">
                                    No
                                </asp:ListItem>
                            </asp:RadioButtonList>  
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
             <div id="divOPDPackage" style="overflow:scroll;max-height:400px;width:100%; text-align: center; " >
                   <div class="Purchaseheader"> OPD Package List&nbsp;</div>
                     <asp:GridView ID="gvOpdPackage" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                    Width="100%" >
                     <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                     <Columns>
                       <asp:TemplateField>
                         <HeaderTemplate>
                        <asp:CheckBox ID="chkOPDPackageSelectAll" runat="server" Text="" ClientIDMode="Static" onclick="javascript:SelectAllCheckboxes(this,'chkOPDPackageSelect');" />
                         </HeaderTemplate>
                             <ItemTemplate>
                            <asp:CheckBox ID="chkOPDPackageSelect" CssClass="chkOPDPackageSelect" ClientIDMode="Static" Checked='<%# Util.GetBoolean(Eval("Checked")) %>' runat="server" Text=""  />                  
                             </ItemTemplate>
                             <ItemStyle CssClass="GridViewItemStyle" Width="30px" />
                             <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                         </asp:TemplateField> 
                         <asp:TemplateField HeaderText="S.No.">                       
                             <ItemTemplate>
                                 <%# Container.DataItemIndex+1 %>    
                                 <asp:Label ID="lblItemID" runat="server" Text='<%#Eval("ID") %>' Visible="false"></asp:Label>                             
                             </ItemTemplate>
                             <ItemStyle CssClass="GridViewItemStyle" Width="30px" />
                             <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                         </asp:TemplateField> 
                          <asp:TemplateField HeaderText="Name">                       
                             <ItemTemplate>                                     
                                 <asp:Label ID="lblPackageName" runat="server" Text='<%#Eval("TypeName") %>' ></asp:Label>                             
                             </ItemTemplate>
                             <ItemStyle CssClass="GridViewItemStyle" Width="200px" HorizontalAlign="Left" />
                             <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                         </asp:TemplateField>                                                 
                          <asp:TemplateField>
                          <HeaderTemplate>
                        Days<br />
                     <asp:TextBox ID="txtheadOPDPackageDays" ClientIDMode="Static" onkeyup="fillText(this,'txtOPDPackageDays')" runat="server" Width="50px" Text=''></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="fc1" runat="server" ValidChars="." TargetControlID="txtheadOPDPackageDays" FilterMode="ValidChars" FilterType="Numbers,Custom"></cc1:FilteredTextBoxExtender>                                                                                                               
                             
                                </HeaderTemplate>
                             <ItemTemplate>    
                             <asp:TextBox ID="txtOPDPackageDays" ClientIDMode="Static" runat="server" Width="50px" Text='<%#Eval("validityDays") %>'></asp:TextBox>
                                 <br />
                                  <cc1:FilteredTextBoxExtender ID="fc2" runat="server" ValidChars="." TargetControlID="txtOPDPackageDays" FilterMode="ValidChars" FilterType="Numbers,Custom"></cc1:FilteredTextBoxExtender>                                                                                                               
                        
                               </ItemTemplate>
                             <ItemStyle CssClass="GridViewItemStyle" Width="50px" HorizontalAlign="Center" />
                             <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" HorizontalAlign="Center" />
                         </asp:TemplateField>                            
                         
                                                  
                        
                     </Columns>
                 </asp:GridView>
                 </div>
                  <asp:CheckBoxList runat="server" Visible="false" ID="cblOPDPackageList" ClientIDMode="Static" RepeatDirection="Horizontal" ></asp:CheckBoxList>
        </div>

        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Membership Card Discounted Details
            </div>
            <div id="divgrd" runat="server" style="overflow: auto; height: 400px;" visible="false">
                <asp:GridView ID="grdSetDiscount" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" OnRowCommand="EmpGrid_RowCommand" Width="100%" OnRowDataBound="grdSetDiscount_RowDataBound">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField>
                            <HeaderTemplate>
                                <asp:CheckBox ID="chkSelectAll" runat="server" Text="" onclick="javascript:SelectAllCheckboxes(this,'chkSelect');" />
                            </HeaderTemplate>
                            <ItemTemplate>
                                <asp:CheckBox ID="chkSelect" runat="server" Text="" Checked='<%#Util.GetBoolean(Eval("isChecked")) %>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="5px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                                <asp:Label ID="lblSubCatID" runat="server" Text='<%#Eval("SubCategoryID") %>' Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Name">
                            <ItemTemplate>
                                <asp:Label ID="lblSubCatName" runat="server" Text='<%#Eval("Name") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Discount In">
                            <HeaderTemplate>
                                <asp:Label runat="server" Text='<%#Eval("Discount In") %>'></asp:Label>
                                <asp:CheckBox ID="chkSelectIsPerOPD" runat="server" Text="IsAmt" onclick="javascript:SelectAllCheckboxes(this,'rbtnIsPerOPD');" />
                            </HeaderTemplate>
                            <ItemTemplate>
                                <asp:RadioButtonList ID="rbtnIsPerOPD" runat="server" RepeatDirection="Horizontal">
                                    <asp:ListItem Value="OP" Selected="True" Text="In Percent"></asp:ListItem>
                                    <asp:ListItem Value="OA" Text="In Amount"></asp:ListItem>
                                </asp:RadioButtonList>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <HeaderTemplate>
                                OPD
                            </HeaderTemplate>
                            <ItemTemplate>
                                <asp:TextBox ID="txtOPDPer" runat="server" Text='<%#Eval("OPD") %>'></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="fc1" runat="server" ValidChars="." TargetControlID="txtOPDPer" FilterMode="ValidChars" FilterType="Numbers,Custom"></cc1:FilteredTextBoxExtender>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Width="100px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <HeaderTemplate>
                                IPD:(%)
                                            <asp:CheckBox ID="chkSelectIsPerIPD" runat="server" Text="IsAmt" Visible="false" onclick="javascript:SelectAllCheckboxes(this,'rbtnIsPerIPD');" />
                            </HeaderTemplate>
                            <ItemTemplate>
                                <asp:TextBox ID="txtIPDPer" runat="server" Text='<%#Eval("IPD") %>'></asp:TextBox>
                                <br />
                                <asp:RadioButtonList ID="rbtnIsPerIPD" runat="server" RepeatDirection="Horizontal" Visible="false">
                                    <asp:ListItem Selected="True" Value="IP" Text="IsPer"></asp:ListItem>
                                    <asp:ListItem Value="IA" Text="IsAmt"></asp:ListItem>
                                </asp:RadioButtonList>
                                <cc1:FilteredTextBoxExtender ID="fc2" runat="server" ValidChars="." TargetControlID="txtIPDPer"
                                    FilterMode="ValidChars" FilterType="Numbers,Custom">
                                </cc1:FilteredTextBoxExtender>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" Width="100px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Exceptional">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemTemplate>
                                <asp:Label ID="lblIsOPDPer" runat="server" Text='<%#Eval("IsOPDPer")%>' Visible="false"></asp:Label>
                                <asp:Label ID="lblIsIPDPer" runat="server" Text='<%#Eval("IsIPDPer")%>' Visible="false"></asp:Label>
                                <asp:ImageButton ID="imbSelect" runat="server" CausesValidation="false" CommandArgument='<%# Eval("SubCategoryID")%>'
                                    CommandName="Select" ImageUrl="~/Images/Post.gif" ToolTip="Select" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="save margin-top-on-btn" OnClick="btnSave_Click" ValidationGroup="save" Enabled="false" />
            <asp:Button ID="btnUpdate" runat="server" Text="Update" CssClass="save margin-top-on-btn" OnClick="btnUpdate_Click" Visible="False" />
            <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="save margin-top-on-btn" OnClick="btnCancel_Click" Visible="False" />
        </div>


        <asp:Panel ID="pnlItem" runat="server" CssClass="pnlItemsFilter" Style="display: none"
            Width="788px" Height="400px">
            <div id="Div4" runat="server" class="Purchaseheader">
                Set Itemwise Discount: 
                <asp:Label ID="lblmsg1" runat="server" Font-Bold="True" Font-Size="9pt" ForeColor="Red"></asp:Label>
            </div>
            <div>
                <div style="text-align: left; width: 733px; vertical-align: middle;">
                    &nbsp;&nbsp;By First Name :  &nbsp;
                    <asp:TextBox ID="txtWord" runat="server" AutoCompleteType="Disabled" CssClass="ItDoseTextinputText"
                        onKeyDown="MoveUpAndDownText(ctl00$ContentPlaceHolder1$txtWord,ctl00$ContentPlaceHolder1$lstInv);"
                        onKeyUp="suggestName(ctl00$ContentPlaceHolder1$txtWord,ctl00$ContentPlaceHolder1$lstInv);"
                        Width="240px" TabIndex="15"></asp:TextBox><asp:Button ID="btnWord" runat="server" CssClass="ItDoseButton" OnClick="btnWord_Click"
                            Text="Search" Width="75px" />

                    <asp:TextBox ID="txtSearch" Visible="false" runat="server" onKeyDown="MoveUpAndDownText(ctl00$ContentPlaceHolder1$txtSearch,ctl00$ContentPlaceHolder1$lstInv);"
                        onKeyUp="suggestName(ctl00$ContentPlaceHolder1$txtSearch,ctl00$ContentPlaceHolder1$lstInv);"
                        CssClass="ItDoseTextinputText" Width="232px" TabIndex="16" /><br />
                    &nbsp;&nbsp;&nbsp;
                    <asp:ListBox ID="lstInv" runat="server" Width="445px" Height="76px" CssClass="ItDoseDropdownbox" />
                    <asp:Button ID="btnSelect" CausesValidation="false" runat="server" CssClass="ItDoseButton"
                        Width="60px" OnClick="btnSelect_Click" Text="Select" TabIndex="17" />
                </div>
            </div>
            <div runat="server" style="overflow: scroll; width: 754px; text-align: left; height: 240px;" visible="false" id="divItem">
                <asp:GridView ID="grdItems" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                    OnRowDataBound="grdItems_RowDataBound" Width="100%" Height="100px">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField>
                            <HeaderTemplate>
                                <asp:CheckBox ID="chkSelectAll" runat="server" Text="" onclick="javascript:SelectAllCheckboxesItems(this,'chkSelect');" />
                            </HeaderTemplate>
                            <ItemTemplate>
                                <asp:CheckBox ID="chkSelect" runat="server" Text="" Checked='<%#Util.GetBoolean(Eval("isChecked")) %>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                                <asp:Label ID="lblItemID" runat="server" Text='<%#Eval("ItemID") %>' Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="ItemName">
                            <ItemTemplate>
                                <asp:Label ID="lblItemName" runat="server" Text='<%#Eval("ItemName") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <HeaderTemplate>
                                OPD:
                                <asp:CheckBox ID="chkSelectIsPerOPD" runat="server" Text="IsAmt" onclick="javascript:SelectAllCheckboxesItems(this,'rbtnIsPerOPD');" />
                            </HeaderTemplate>
                            <ItemTemplate>
                                <asp:TextBox ID="txtOPDPer" runat="server" Width="35px" Text='<%#Eval("OPD") %>'></asp:TextBox>
                                <br />
                                <asp:RadioButtonList ID="rbtnIsPerOPD" Width="35px" runat="server" RepeatDirection="Horizontal">
                                    <asp:ListItem Value="OP" Selected="True" Text="IsPer"></asp:ListItem>
                                    <asp:ListItem Value="OA" Text="IsAmt"></asp:ListItem>
                                </asp:RadioButtonList>
                                <cc1:FilteredTextBoxExtender ID="fc1" runat="server" ValidChars="." TargetControlID="txtOPDPer" FilterMode="ValidChars" FilterType="Numbers,Custom"></cc1:FilteredTextBoxExtender>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" HorizontalAlign="Center" />
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <HeaderTemplate>
                                IPD:(%)
                                <asp:CheckBox ID="chkSelectIsPerIPD" runat="server" Text="IsAmt" Visible="false" onclick="javascript:SelectAllCheckboxesItems(this,'rbtnIsPerIPD');" />
                            </HeaderTemplate>
                            <ItemTemplate>
                                <asp:TextBox ID="txtIPDPer" runat="server" Width="35px" Text='<%#Eval("IPD") %>'></asp:TextBox>
                                <br />
                                <asp:RadioButtonList ID="rbtnIsPerIPD" Width="35px" runat="server" RepeatDirection="Horizontal" Visible="false">
                                    <asp:ListItem Selected="True" Value="IP" Text="IsPer"></asp:ListItem>
                                    <asp:ListItem Value="IA" Text="IsAmt"></asp:ListItem>
                                </asp:RadioButtonList>
                                <cc1:FilteredTextBoxExtender ID="fc2" runat="server" ValidChars="." TargetControlID="txtIPDPer" FilterMode="ValidChars" FilterType="Numbers,Custom"></cc1:FilteredTextBoxExtender>

                                <asp:Label ID="lblIsOPDPer" runat="server" Text='<%#Eval("IsOPDPer")%>' Visible="false"></asp:Label>
                                <asp:Label ID="lblIsIPDPer" runat="server" Text='<%#Eval("IsIPDPer")%>' Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" HorizontalAlign="Center" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
            <div style="text-align: center;">
                <asp:Button ID="btnSaveItem" runat="server" CssClass="ItDoseButton" Text="Save" OnClick="btnSaveItem_Click"
                    Width="45px" />&nbsp;<asp:Button ID="btnstaffcancel"
                        runat="server" CssClass="ItDoseButton" Text="Cancel" Width="60px" />
            </div>
        </asp:Panel>
        <asp:Button ID="btnhidden" runat="server" Text="Button" Style="display: none;" />
        <cc1:ModalPopupExtender ID="mpeItem" runat="server" BackgroundCssClass="filterPupupBackground"
            CancelControlID="btnstaffcancel" DropShadow="true" PopupControlID="pnlItem"
            TargetControlID="btnhidden">
        </cc1:ModalPopupExtender>


    </div>

      <script type="text/javascript">
          $(document).ready(function () {
              divOPDPackageToggle();
              $('#cblOPDPackageList input').removeAttr('checked');
              $('#rblIsOPDPackage input').live('click', function () {
                  divOPDPackageToggle();
              });
          });
          function divOPDPackageToggle() {
              if ($('#rblIsOPDPackage input:checked').val() == "Yes") {
                  $('#divOPDPackage').show();
                  $('#<%=gvOpdPackage.ClientID %>').show();
                    $('#<%=gvOpdPackage.ClientID %>').css('width', '100%');
                } else {
                    $('#divOPDPackage').hide();
                    $('#chkOPDPackageSelectAll input').removeAttr('checked');
                    $('#<%=gvOpdPackage.ClientID %>').not(":first").each(function () {
                        if ($(this).closest("tr").find('#txtOPDPer').val() == "") {
                            $(this).closest("tr").find('#chkOPDPackageSelect input').removeAttr('checked');
                        }
                    });

                }
            }
            function fillText(txt, txtName) {
                if (txtName == "txtOPDPackageDays") {
                    $('#<%=gvOpdPackage.ClientID %>').find($('input:text[name$="' + txtName + '"]')).each(function () {
                    if (this != txt) {
                        $(this).val($(txt).val());
                    }
                });
            }
            else if (txtName == "txtOPDPer") {
                $('#<%=grdSetDiscount.ClientID %>').find($('input:text[name$="' + txtName + '"]')).each(function () {
                    if (this != txt) {
                        $(this).val($(txt).val());
                    }
                });
            }
    }
    </script>

</asp:Content>

