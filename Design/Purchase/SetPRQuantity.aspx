<%@ Page  Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="SetPRQuantity.aspx.cs" ClientIDMode="Static" Inherits="Design_Purchase_SetPRQuantity" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <script type = "text/javascript">
        function ClientItemSelected(sender, e) {
            $get("<%=hfItemId.ClientID %>").value = e.get_value();
            if ($get("<%=hfItemId.ClientID %>").value == "No match found.") {
                $get("<%=txtItemName.ClientID %>").value = "";
            }
        }
        
</script>
    <script type="text/javascript">
        function SetContextKey() {
            $find('AutoCompleteEx').set_contextKey($get("<%=rdoStoretype.ClientID%> input[type:radio]:checked").value);
        }

        function validate(btn) {
            if ($("#txtItemName").val() == "") {
                $("#lblMsg").text('Please Enter Item Name');
                $("#txtItemName").focus();
                return false;
            }
            if (($("#txtLMcon").val() == "") || ($("#txtLMcon").val()<=0)) {
                $("#lblMsg").text('Please Enter Last Month Consumption');
                $("#txtLMcon").focus();
                return false;
            }
            if (($("#txtDepStockQty").val() == "") || ($("#txtDepStockQty").val()<=0)) {
                $("#lblMsg").text('Please Enter Department Stock Maintain');
                $("#txtDepStockQty").focus();
                return false;
            }
            

            if ($("#chklDept input[type=checkbox]:checked").length == "0") {
                $("#lblMsg").text('Please Select Department');
                $("#chklDept input[type=checkbox]").focus();
                return false;
            }
            btn.disabled = true;
            btn.value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');
        }

        function chkCurrentQuantity() {
            var LMCon = parseFloat($("#txtLMcon").val());
            if (isNaN(LMCon) || LMCon == "")
                LMCon = 0;
            var DepStockQty =Number( $("#txtDepStockQty").val());
            if (isNaN(DepStockQty) || DepStockQty == "")
                DepStockQty = 0;
           
            if (parseFloat(DepStockQty) > parseFloat(LMCon)) {
                $("#lblMsg").text('Please Enter Valid Department Stock Maintain');
                $("#txtDepStockQty").val(0);
                return;
            }


                var CurrentQtyRel = 0;
            if (parseFloat(DepStockQty) > 0)
                CurrentQtyRel = Math.ceil( parseFloat(LMCon) / (30/parseFloat(DepStockQty)));
            else
                CurrentQtyRel = parseFloat(LMCon);
            parseFloat($("#txtCurrentQtyRel").val(CurrentQtyRel));
        }
</script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align:center">
           
                    <b>Set Purchase Request Quantity</b>
                    <br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
               
        </div>
         <div class="POuter_Box_Inventory">
            <table style="width: 100%;border-collapse:collapse">
                <tr>
                    <td style="text-align: right;width:20%"> 
                        Store Type :&nbsp;
                       
                    </td>
                    <td style="text-align: left;width:30%">
                         <asp:RadioButtonList ID="rdoStoretype"  runat="server" RepeatDirection="Horizontal" ClientIDMode="Static"  >
                        <asp:ListItem Selected="True" Value="11">Medical Items</asp:ListItem>   
                        <asp:ListItem  Value="28">General Items</asp:ListItem>
                            
                        </asp:RadioButtonList>
                    </td>
                    <td style="text-align: right;width:20%"> 
                        &nbsp;
                    </td>
                   <td style="text-align: left;width:30%">
                        &nbsp;
                    </td>
                </tr>
                <tr>
                  <td style="text-align: right"> 
                        Item Name :&nbsp;
                    </td>
                      <td style="text-align: left" colspan="2">
                          <asp:TextBox ID="txtItemName" runat="server" MaxLength="100" Width="420px" onkeyup = "SetContextKey()"></asp:TextBox>
                           <span style="color: red; font-size: 10px;" class="shat">*</span>
                          <asp:HiddenField ID="hfItemId" runat="server" />
                            </td>
                </tr>
                <tr>
                  <td style="text-align: right"> 
                        Last Month Consumption :&nbsp;
                    </td>
                      <td style="text-align: left">
                          <asp:TextBox ID="txtLMcon" runat="server" MaxLength="100" Width="80px" onkeyup="chkCurrentQuantity()"></asp:TextBox>
                           <span style="color: red; font-size: 10px;" class="shat">*</span>
                          <cc1:FilteredTextBoxExtender ID="ftbLMCon" runat="server" TargetControlID="txtLMcon" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                            </td>
                     <td style="text-align: right"> 
                        Department&nbsp;Stock&nbsp;Maintain&nbsp;:&nbsp;
                    </td>
                    <td style="text-align: left">
                       <asp:TextBox ID="txtDepStockQty" runat="server" MaxLength="100" Width="80px" onkeyup="chkCurrentQuantity()"></asp:TextBox>
                         <span style="color: red; font-size: 10px;" class="shat">*</span>
                        <cc1:FilteredTextBoxExtender ID="ftbDeptStockQty" runat="server" TargetControlID="txtDepStockQty" FilterType="Numbers"></cc1:FilteredTextBoxExtender>

                    </td>
                </tr>
                  <tr>
                  <td style="text-align: right"> 
                        Current&nbsp;Quantity&nbsp;Requested&nbsp;:&nbsp;
                    </td>
                      <td style="text-align: left">
                          <asp:TextBox ID="txtCurrentQtyRel" runat="server" MaxLength="100" Width="80px"></asp:TextBox>
                           <cc1:FilteredTextBoxExtender ID="ftbCurrentQty" runat="server" TargetControlID="txtCurrentQtyRel" FilterType="Numbers"></cc1:FilteredTextBoxExtender>

                            </td>
                     <td style="text-align: right"> 
                        &nbsp;
                    </td>
                    <td style="text-align: left">
                       &nbsp;
                    </td>
                </tr>
                <tr>
                  <td style="text-align: right"> 
                         Max. :&nbsp;
                    </td>
                      <td style="text-align: left">
                            <asp:TextBox ID="txtMax" runat="server" MaxLength="100" Width="80px"></asp:TextBox>
                                            <cc1:FilteredTextBoxExtender ID="ftbMax" runat="server" TargetControlID="txtMax" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
        
                            </td>
                    <td style="text-align: right"> 
                        Min :&nbsp;
                    </td>
                     <td style="text-align: left">
                          <asp:TextBox ID="txtMin" runat="server" MaxLength="100" Width="80px"></asp:TextBox>
                                                <cc1:FilteredTextBoxExtender ID="ftbMin" runat="server" TargetControlID="txtMin" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
     
                    </td>
                </tr>
                <tr>
                  <td style="text-align: right"> 
                      Department :&nbsp;
                      </td>
                      <td style="text-align: left"  colspan="3">
                          <asp:CheckBoxList ID="chklDept" runat="server"  RepeatDirection="Horizontal" RepeatLayout="Table" RepeatColumns="5"></asp:CheckBoxList>
                         </td>

                    </tr>
                </table>

             </div>
        <div class="POuter_Box_Inventory" style="text-align:center">
            <asp:Button ID="btnAdd" runat="server" CssClass="ItDoseButton" Text="Add" OnClick="btnAdd_Click" Visible="false" />
             <asp:Button ID="btnSave" runat="server" CssClass="ItDoseButton" Text="Save" OnClick="btnSave_Click" OnClientClick="return validate(this)" />
            </div>
         <div class="POuter_Box_Inventory">
        <asp:GridView ID="grdPR"  runat="server"  BorderStyle="Solid" OnRowCreated="grdPR_RowCreated" CssClass="GridViewStyle"  BorderWidth="1px" CellPadding="4" OnRowDataBound="grdPR_RowDataBound">
            <Columns>    
            <asp:TemplateField HeaderText="S.No.">
                                                        <ItemTemplate>
                                                       <%#Container.DataItemIndex+1 %>
                                                        </ItemTemplate>
                                                        <ItemStyle CssClass="GridViewLabItemStyle" />
                                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                                                    </asp:TemplateField>
                 <asp:TemplateField>
                    <ItemTemplate>
                     <asp:Label ID="lblItemName" runat="server" Text='<%#Eval("ItemName") %>' ></asp:Label>      
                         <asp:Label ID="lblItemID" runat="server" Text='<%#Eval("ItemID") %>'  Visible="false"></asp:Label>  
                                                
                    </ItemTemplate>
                      <ItemStyle CssClass="GridViewLabItemStyle" />
                  <HeaderStyle CssClass="GridViewHeaderStyle" Width="220px" />
                </asp:TemplateField>
                 
    </Columns>
        </asp:GridView>
             </div>
        </div>
           <cc1:AutoCompleteExtender runat="server" ID="autoComplete1" TargetControlID="txtItemName"
        FirstRowSelected="true" BehaviorID="AutoCompleteEx" ServicePath="~/Design/Purchase/Services/StoreItemSearch.asmx"
        ServiceMethod="SearchItems" MinimumPrefixLength="2" EnableCaching="true" UseContextKey="true"
        CompletionSetCount="20" CompletionInterval="1000" CompletionListCssClass="autocomplete_completionListElement"
        CompletionListItemCssClass="autocomplete_listItem" ShowOnlyCurrentWordInCompletionListItem="true" OnClientItemSelected = "ClientItemSelected"
        CompletionListHighlightedItemCssClass="autocomplete_highlightedListItem">
        <Animations>
         
                    <OnShow>
                        <Sequence>
                            <%-- Make the completion list transparent and then show it --%>
                            <OpacityAction Opacity="0" />
                            <HideAction Visible="true" />
                            
                            <%--Cache the original size of the completion list the first time
                                the animation is played and then set it to zero --%>
                            <ScriptAction Script="
                                // Cache the size and setup the initial size
                                var behavior = $find('AutoCompleteEx');
                                if (!behavior._height) {
                                    var target = behavior.get_completionList();
                                    behavior._height = target.offsetHeight - 2;
                                    target.style.height = '0px';
                                }" />
                            
                            <%-- Expand from 0px to the appropriate size while fading in --%>
                            <Parallel Duration=".4">
                                <FadeIn />
                                <Length PropertyKey="height" StartValue="0" EndValueScript="$find('AutoCompleteEx')._height" />
                            </Parallel>
                        </Sequence>
                    </OnShow>
                    <OnHide>
                        <%-- Collapse down to 0px and fade out --%>
                        <Parallel Duration=".4">
                            <FadeOut />
                            <Length PropertyKey="height" StartValueScript="$find('AutoCompleteEx')._height" EndValue="0" />
                        </Parallel>
                    </OnHide>
        </Animations>
    </cc1:AutoCompleteExtender>
</asp:Content>

