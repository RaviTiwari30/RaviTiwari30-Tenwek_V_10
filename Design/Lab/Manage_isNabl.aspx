<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="Manage_isNabl.aspx.cs" Inherits="Design_Lab_Manage_isNabl" Title="Untitled Page" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
 <%--Search--%>   
  <script type="text/javascript">
      $(function () {
          $('.chosen-container').css('width', '230px');
      });
      var PatientData = "";
      function Search() {
          $('#IsNable').val('0');
          $.ajax({
              url: "../Lab/Services/MapInvestigationObservation.asmx/GetNablInvestigations",
              data: '{ CentreId: "' + $("#ddlCentre").val() + '",SubCategoryId: "' + $("#<%=ddlSubCategory.ClientID %>").val() + '"}', // parameter map
              type: "POST", // data has to be Posted    	        
              contentType: "application/json; charset=utf-8",
              timeout: 120000,
              dataType: "json",
              success: function (result) {
                  PatientData = $.parseJSON(result.d);
                  if (PatientData.length != 0) {
                      $("#btnSave").show();
                  }
                  else
                      $("#btnSave").hide();

                  var output = $('#tb_InvestigationItems').parseTemplate(PatientData);
                  $('#div_InvestigationItems').html(output);
                  if ($("#<%=ddlSubCategory.ClientID %>").val() == 'All') {
                      $('#tb_grdLabSearch tr').hide();
                      $("#chkheader").hide();
                  }
                  tabfunc();
              },
              error: function (xhr, status) {
                  modelAlert("Error ");

                  window.status = status + "\r\n" + xhr.responseText;
              }
          });

      }
   </script>
   <%--TableFunctions--%>
 <script type="text/javascript">
     function tabfunc() {

         $("#chkheader").click(function () {
             if ($('#chkheader').is(':checked')) { $('input[type="checkbox"]').prop('checked', true); }
             else { $('input[type="checkbox"]').prop('checked', false); }
         });
     }

 </script>  
 <script type="text/javascript">
     $(document).ready(function () {
         Search();
     });

 </script>
 <%--Filtering--%>
 <script type="text/javascript">
     $(document).ready(function () {
         $("#txtTestname").keyup(function () {
             var val = $(this).val();
             var len = $(this).val().length;

             if (val != "" || ($("#<%=ddlSubCategory.ClientID %>").val() == 'All'))
                 $("#chkheader").hide();
             else
                 $("#chkheader").show();

             $("#tb_grdLabSearch tr").hide();
             $("#tb_grdLabSearch tr:first").show();

             var searchtype = $("#<%=rblsearchtype.ClientID%>").find('input[checked]').val();

             if (searchtype == "0") {

                 $("#tb_grdLabSearch tr").find("td:eq(" + 2 + ") ").filter(function () {
                     if (val == "" && ($("#<%=ddlSubCategory.ClientID %>").val() == 'All')) {
                         return $(this).parent('tr').find(':checkbox').attr('checked');
                     }
                     else {
                         if ($(this).text().substring(0, len).toLowerCase() == val.toLowerCase() || $(this).parent('tr').find(':checkbox').attr('checked'))
                             return $(this);
                     }
                 }).parent('tr').show();
             }
             else {
                 $("#tb_grdLabSearch tr").find("td:eq(" + 2 + ") ").filter(function () {
                     if (val == "" && ($("#<%=ddlSubCategory.ClientID %>").val() == 'All')) {
                         return $(this).parent('tr').find(':checkbox').attr('checked');
                     }
                     else {
                         if ($(this).text().toLowerCase().match(val.toLowerCase()) || $(this).parent('tr').find(':checkbox').attr('checked'))
                             return $(this);
                     }
                 }).parent('tr').show();
             }
         });
     });
    </script>
   <div id="Pbody_box_inventory" >
    <div class="POuter_Box_Inventory" >
    <div style="text-align:center;">
    <b>Manage ISO</b></div>
     <asp:Label ID="lblMsg" runat="server" Style="color: red;" Font-Bold="true"></asp:Label>
   </div>
     <div class="Outer_Box_Inventory" style="width:1294px;" >

    <div class="Purchaseheader" style="width: 1291px; " > 
        <div class="row"> Search criteria</div>
       </div>
       <div class="row" id="TBMain">
            <div class="col-md-3" id="dtDept" runat="server">
                    <label class="pull-left">
                        Centre
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlCentre" class="ddlCentre chosen-select chosen-container" runat="server" ClientIDMode="Static" onchange="Search();">
                                </asp:DropDownList>
                </div>
           <div class="col-md-3"   >
                    <label class="pull-left">
                        SubCategory
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                   <asp:DropDownList ID="ddlSubCategory" runat="server" onchange="Search()" CssClass="ms-choice" ClientIDMode="Static"
                                    Width="228px" > </asp:DropDownList>
                </div>
            <div class="col-md-3"   >
                    <label class="pull-left">
                        Test Name
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                  <input id="txtTestname" type="text" style="width: 222px; cursor:default;"  class="ms-choice"/> 
                </div>
           
       </div>
       <div class="row">
              <div class="col-md-3"   >
                    <label class="pull-left">
                        Search By Name
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                 <asp:RadioButtonList ID="rblsearchtype" runat="server" RepeatDirection="Horizontal">
                                    <asp:ListItem Selected="True" Value="0">By First Name</asp:ListItem>
                                    <asp:ListItem Value="1">In Between</asp:ListItem>
                                </asp:RadioButtonList>
                </div>
               </div>
            </div> 
         <div class="POuter_Box_Inventory"> 
        <div id="div_InvestigationItems"  style="max-height:421px; overflow-y:auto; overflow-x:hidden;">
                
            </div>
        </div>
        
        <div class="POuter_Box_Inventory" style="text-align:center"  >
        <input id="btnSave" type="button" value="Save"  onclick="save();" class="ItDoseButton" style="width:60px; display:none;"   />
        </div>
        
        
      
   </div>
   
      <script id="tb_InvestigationItems" type="text/html">
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdLabSearch" 
    style="border-collapse:collapse;width:100%;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;">S.No</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:90px;">Sub category</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:730px;">Item Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:70px;">DayType</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;"> <input id="chkheader" type="checkbox"  /></th>
	       

</tr>

       <#
       
              var dataLength=PatientData.length;
              window.status="Total Records Found :"+ dataLength;
              var objRow;   
        for(var j=0;j<dataLength;j++)
        {

        objRow = PatientData[j];
         
            #>
                    <tr id="<#=objRow.SubCategoryID#>|<#=objRow.Type_ID#>" >
<td class="GridViewLabItemStyle"><#=j+1#></td>
<td id="SubCategoryID"  class="GridViewLabItemStyle"><#=objRow.DeptName#></td>
<td id="InvName" class="GridViewLabItemStyle" Style="width:200px"><#=objRow.InvName#></td>
<td id="isNABL" class="GridViewLabItemStyle" Style="width:340px">
<input id="rdNA"  type="radio" name="radio<#=j+1#>" value="0"  style="cursor:pointer;" <#if(objRow.isNABL=="0"){#>checked="checked"<#}#>/>NA &nbsp;
<input id="rdNABL" type="radio" name="radio<#=j+1#>" value="1" style="cursor:pointer;" <#if(objRow.isNABL=="1"){#>checked="checked"<#}#> />NABL &nbsp;
<input id="Radio1" type="radio" name="radio<#=j+1#>" value="2" text="CAP" style="cursor:pointer;" <#if(objRow.isNABL=="2"){#>checked="checked"<#}#> /> CAP/ISO&nbsp;
<input id="rdCAP" type="radio" name="radio<#=j+1#>" value="5" text="NABL+CAP" style="cursor:pointer;" <#if(objRow.isNABL=="5"){#>checked="checked"<#}#> /> NABL+CAP &nbsp;    
</td>

<td class="GridViewLabItemStyle" style="width:10px;"><input id="chk" type="checkbox" /></td>

</tr>

<#}#>

     </table>    
    </script>
    
 

     <script type="text/javascript">
         function save() {

             var ItemData = "";
             $("#tb_grdLabSearch tr").find('#chk').filter(':checked').each(function () {
                 var $rowid = $(this).closest('tr');
                 ItemData += $rowid.attr("ID") + "|" + $rowid.find("#isNABL").find(":radio:checked").val() + "#";
             });
             if ($("#ddlCentre").val() == null || $("#ddlCentre").val() == "") {
                 modelAlert("Please select a centre..! ");
                 return;
             }
             if (ItemData == "") {
                 modelAlert("Please select an Investigation ");
                 $("#btnSave").attr('disabled', false);
                 return;
             }
             $("#btnSave").attr('disabled', true);
             $.ajax({
                 url: "../Lab/Services/MapInvestigationObservation.asmx/Save_isNABLInv",
                 data: '{CentreId: "' + $("#ddlCentre").val() + '",SubCategoryId: "' + $("#<%=ddlSubCategory.ClientID %>").val() + '", ItemData: "' + ItemData + '"}', // parameter map
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {
                     if (result.d == "1") {
                         $('input[type="checkbox"]').prop('checked', false);
                         modelAlert("Record Saved Successfully");
                     }
                     else {
                         modelAlert("Record Not Saved");
                     }

                     $("#btnSave").attr('disabled', false);
                 },
                 error: function (xhr, status) {
                     modelAlert("Error has occured Record Not saved ");
                     $("#btnSave").attr('disabled', false);
                     window.status = status + "\r\n" + xhr.responseText;
                 }
             });
         }

 </script>

</asp:Content>

