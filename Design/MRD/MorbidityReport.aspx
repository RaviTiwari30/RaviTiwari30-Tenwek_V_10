<%@ Page Language="C#" MaintainScrollPositionOnPostback="true" MasterPageFile="~/DefaultHome.master"
    AutoEventWireup="true" CodeFile="MorbidityReport.aspx.cs" Inherits="Design_MRD_MorbidityReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Morbidity Report </b>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Report Critaria
            </div>
           <div class="row">
               <div class="col-md-1"></div>
               <div class="col-md-22">
                   <div class="col-md-3">
                       <label class="pull-left">ICDCode</label>
                       <b class="pull-right">:</b>
                   </div>
                   <div class="col-md-5">
                       <asp:TextBox ID="txtCode" runat="server" TabIndex="6" autocomplete="off" ></asp:TextBox>
                       <asp:TextBox ID="txtDig" runat="server" autocomplete="off" TabIndex="6" style="display:none"></asp:TextBox>
                   </div>
                   <div class="col-md-3">
                       <label class="pull-left">From Date</label>
                       <b class="pull-right">:</b>
                   </div>
                   <div class="col-md-5">
                        <asp:TextBox ID="EntryDate1" runat="server" ></asp:TextBox>
                            <cc1:CalendarExtender ID="calucDate1" runat="server" Format="dd-MMM-yyyy" TargetControlID="EntryDate1">
                            </cc1:CalendarExtender>
                   </div>
                   <div class="col-md-3">
                       <label class="pull-left">To Date</label>
                       <b class="pull-right">:</b>
                   </div>
                   <div class="col-md-5">
                        <asp:TextBox ID="EntryDate2" runat="server" ></asp:TextBox>
                            <cc1:CalendarExtender ID="calucDate2" runat="server" Format="dd-MMM-yyyy" TargetControlID="EntryDate2">
                            </cc1:CalendarExtender>
                   </div>
               </div>
               <div class="col-md-1"></div>

           </div>
                
           <cc1:AutoCompleteExtender runat="server" ID="autoComplete1" TargetControlID="txtDig"
            FirstRowSelected="true" BehaviorID="AutoCompleteEx" ServicePath="~/Design/MRD/Services/ICDAutoComplete.asmx"
            ServiceMethod="GetCompletionList" MinimumPrefixLength="2" EnableCaching="true"
            CompletionSetCount="20" CompletionInterval="1000" CompletionListCssClass="autocomplete_completionListElement"
            CompletionListItemCssClass="autocomplete_listItem" ShowOnlyCurrentWordInCompletionListItem="true"
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
        <cc1:AutoCompleteExtender runat="server" ID="AutoCompleteExtender2" TargetControlID="txtCode"
            FirstRowSelected="true" BehaviorID="AutoCompleteEx1" ServicePath="~/Design/MRD/Services/ICDAutoComplete.asmx"
            ServiceMethod="GetCompletionListCode" MinimumPrefixLength="1" EnableCaching="true"
            CompletionSetCount="20" CompletionInterval="1000" CompletionListCssClass="autocomplete_completionListElement"
            CompletionListItemCssClass="autocomplete_listItem" ShowOnlyCurrentWordInCompletionListItem="true"
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
                                var behavior = $find('AutoCompleteEx1');
                                if (!behavior._height) {
                                    var target = behavior.get_completionList();
                                    behavior._height = target.offsetHeight - 2;
                                    target.style.height = '0px';
                                }" />
                            
                            <%-- Expand from 0px to the appropriate size while fading in --%>
                            <Parallel Duration=".4">
                                <FadeIn />
                                <Length PropertyKey="height" StartValue="0" EndValueScript="$find('AutoCompleteEx1')._height" />
                            </Parallel>
                        </Sequence>
                    </OnShow>
                    <OnHide>
                        <%-- Collapse down to 0px and fade out --%>
                        <Parallel Duration=".4">
                            <FadeOut />
                            <Length PropertyKey="height" StartValueScript="$find('AutoCompleteEx1')._height" EndValue="0" />
                        </Parallel>
                    </OnHide>
            </Animations>
        </cc1:AutoCompleteExtender>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="row" style="text-align:center">

           <div class="col-md-24">

            <asp:Button ID="btnPreview" runat="server" OnClick="btnPreview_Click" Text="Preview"
                TabIndex="11" CssClass="ItDoseButton" Width="110px" />
            &nbsp; &nbsp; &nbsp;
            <asp:Button ID="btnGovt" runat="server" OnClick="btnGovt_Click" Text="Govt. Report"
                TabIndex="11" CssClass="ItDoseButton"   style="display:none"/>
             &nbsp; &nbsp; &nbsp;
            <asp:Button ID="btnSummary" runat="server" OnClick="btnSummary_Click" Text="Summary" />
        </div>
                </div>
            </div>
    </div>
</asp:Content>
