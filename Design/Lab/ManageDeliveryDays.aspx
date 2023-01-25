<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="ManageDeliveryDays.aspx.cs" Inherits="Design_Investigation_ManageDeliveryDays" Title="Untitled Page" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
       
<script type="text/javascript" src="../../Scripts/TimePicker/jquery.ui.timepicker.js"></script>  
<link href="../../Scripts/TimePicker/jquery.ui.timepicker.css" rel="stylesheet" type="text/css" />
  
  <script type="text/javascript">
      var PatientData = "";
      var _PageSize;
      var _PageNo = 0;
      function Search() {
          $.blockUI();
          $.ajax({

              url: "ManageDeliveryDays.aspx/GetDeliveryDays",
              data: '{ CentreId: "' + $("#<%=ddlCentreAccess.ClientID %>").val() + '",SubCategoryId: "' + $("#<%=ddlDepartment.ClientID %>").val() + '",TestName:"' + $("#txtTestname").val() + '",TestCode:"' + $("#txtTestCode").val() + '"}', // parameter map
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
                  _PageSize = 300;
                  _PageNo = 0;
                  var output = $('#tb_InvestigationItems').parseTemplate(PatientData);
                  $('#div_InvestigationItems').html(output);
                  $(".timepiker").timepicker();
                  $.unblockUI();
                  Func();
              },
              error: function (xhr, status) {
                  modelAlert(xhr.responseText);
                  //showerrormsg(xhr.responseText);
                  $.unblockUI();
                  window.status = status + "\r\n" + xhr.responseText;
              }
          });
      }
      function nmrcOnly(ctrl) {
          if ($(ctrl).val().indexOf(".") != -1) {
              $(ctrl).val($(ctrl).val().replace('.', ''));
          }
          if ($(ctrl).val().indexOf(" ") != -1) {
              $(ctrl).val($(ctrl).val().replace(' ', ''));
          }

          var nbr = $(ctrl).val();
          var decimalsQty = nbr.replace(/[^.]/g, "").length;
          if (parseInt(decimalsQty) > 1) {
              $(ctrl).val($(ctrl).val().substring(0, $(ctrl).val().length - 1));
          }

          // alert($(ctrl).closest("tr").find("#txttddisc").text());

          if ($(ctrl).val().length > 1) {
              if (isNaN($(ctrl).val() / 1) == true) {
                  $(ctrl).val($(ctrl).val().substring(0, $(ctrl).val().length - 1));
              }
          }


          if (isNaN($(ctrl).val() / 1) == true) {
              $(ctrl).val('');

              return;
          }
          else if ($(ctrl).val() < 0) {
              $(ctrl).val('');

              return;
          }

      }
   </script>
  
 
 <script type="text/javascript">
     $(document).ready(function () {
         var output = $('#tb_InvestigationItems').parseTemplate(PatientData);
         $('#div_InvestigationItems').html(output);
         $(".timepiker").timepicker();
         var config = {
             '.chosen-select': {},
             '.chosen-select-deselect': { allow_single_deselect: true },
             '.chosen-select-no-single': { disable_search_threshold: 10 },
             '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' },
             '.chosen-select-width': { width: "95%" }
         }
         for (var selector in config) {
             $(selector).chosen(config[selector]);
         }
     });

     $(document).on('click', '#chkheader', function () {
         if ($("#chkheader").is(":checked")) {

             $("#tb_grdLabSearch tr").find("#chk").prop("checked", true);

         }
         else {

             $("#tb_grdLabSearch tr").find("#chk").prop("checked", false);

         }
     });


     function showme(ctrl) {
         var val = $(ctrl).val();
         var name = $(ctrl).attr("name");

         $('input[name="' + name + '"]').each(function () {
             $(this).val(val);
         });


     }


 </script>
 
<Ajax:ScriptManager AsyncPostBackErrorMessage="Error..." ID="ScriptManager1" runat="server">
</Ajax:ScriptManager>
      <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111"><%--durga msg changes--%>
        <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
    </div>
   <div id="Pbody_box_inventory" style="width: 1306px;" >
    <div class="Outer_Box_Inventory" style="width: 1300px; " >
    <div style="text-align:center;">
    <b>Manage Delivery Days(TAT)</b></div>
   </div>
   <div class="Outer_Box_Inventory" style="width:1300px;" >

    <div class="Purchaseheader" style="width: 1300px; " > 
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
                   <asp:DropDownList ID="ddlCentreAccess" class="ddlcentreAccess  chosen-select chosen-container" Width="235px" runat="server"></asp:DropDownList>
                </div>
           <div class="col-md-3"   >
                    <label class="pull-left">
                        Department
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                   <asp:DropDownList ID="ddlDepartment"  Width="235px" runat="server" class="ddlDepartment  chosen-select chosen-container">
                        </asp:DropDownList>
                </div>
            <div class="col-md-3"   >
                    <label class="pull-left">
                        Test Name
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                  <input id="txtTestname" type="text" style="width: 235px"  class="1"/>  
                </div>
           
       </div>
       <div class="row">
              <div class="col-md-3"   >
                    <label class="pull-left">
                        Test Code
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                  <input id="txtTestCode" type="text" style="width: 235px"  class="1"/> 
                </div>
               </div>
            </div>    
        <div class="Outer_Box_Inventory" style="width: 1300px; text-align:center"  >
        <input id="btnSearch" type="button" value="Search"  onclick="Search();" class="searchbutton"   />
          &nbsp;&nbsp;     <input id="btnSave" type="button" value="Save"  onclick="save();" class="savebutton" style= "display:none;"   />
            <br />
           <center>
            <table  style="width:80%;border-collapse:collapse;">
                        <tr>
                            <td>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            </td>
                            <td style="width: 25px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color:  #FC834E;" >
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td>
                              &nbsp;<b>Pre Analytical TAT</b></td> 
                              <td style="width: 25px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color:  #f5cfe9;" >
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td>
                              &nbsp;<b>Analytical TAT (Department receive to Approval)</b></td>
                              <td style="width: 25px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color:  #7BFA6A;" >
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td>
                              &nbsp;<b>Post Analytical TAT
</b></td>
                           
                        </tr>
                    </table>

               </center>
        </div>
       <div class="POuter_Box_Inventory" style="width: 1300px; "  > 
         <div class="Purchaseheader">
                Search Result
            </div>
           <div id="div_InvestigationItems" >

                
            </div>
        
        
        </div>
        
       
        
        
      
   </div>
   
      <script id="tb_InvestigationItems" type="text/html">
            
          <# if(_PageNo==0){#>
        
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdLabSearch"  style="width: 100%;table-layout:fixed;">
		<thead>
            <tr>
                <th class="GridViewHeaderStyle" scope="col" style="width: 25px;">#</th>
                <th class="GridViewHeaderStyle" scope="col" align="left" style="width: 140px;">Test Name</th>
                  <th class="GridViewHeaderStyle" scope="col" align="left" style="width: 70px;">Test Code</th>               
                <th class="GridViewHeaderStyle" scope="col" style="width: 100px;">Booking cutoff
                     <input type="text" style="width:80px;" name="bookingcutoff" onblur="showme(this)"  class="bookingcutoff timepiker" value="6:30pm"  />
                </th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 100px;">SRA cutoff
                     <input type="text" style="width:80px;" name="sracutoff" onblur="showme(this)"  class="sracutoff timepiker" value="8:30am"  />
                </th>
                 <th class="GridViewHeaderStyle" scope="col" style="width:260px;">
			<div  id="div_WeeksHead_Proc" >
                Technician Proccessing
                <br />
<label id="chkSunHead_Proc"  style="cursor:pointer;"  onclick="chkAll(this,'chkSun_Proc')">Sun </label> &nbsp;
<label id="chkMonHead_Proc"  style="cursor:pointer;"  onclick="chkAll(this,'chkMon_Proc')">Mon </label> &nbsp;
<label id="chkTueHead_Proc"  style="cursor:pointer;"  onclick="chkAll(this,'chkTue_Proc')">Tue </label> &nbsp;
<label id="chkWedHead_Proc"  style="cursor:pointer;"  onclick="chkAll(this,'chkWed_Proc')">Wed </label> &nbsp;
<label id="chkThuHead_Proc"  style="cursor:pointer;"  onclick="chkAll(this,'chkThu_Proc')">Thu </label> &nbsp; 
<label id="chkFriHead_Proc"  style="cursor:pointer;"  onclick="chkAll(this,'chkFri_Proc')">Fri </label> &nbsp;
<label id="chkSatHead_Proc"  style="cursor:pointer;"  onclick="chkAll(this,'chkSat_Proc')">Sat </label> &nbsp;
</div>
			</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;">DayType
                     <select onchange="ChangeDays(this)">
                        <option value="Day">Day</option>
                        <option value="WeekDay">Week Day</option>
                     </select>
                </th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 100px;">Processing days
                     <input type="text" style="width:80px;" name="testprocessingday" onblur="showme(this)"  onkeyup="nmrcOnly(this)" class="testprocessingday" value="0"  />
                </th>
                <th class="GridViewHeaderStyle" scope="col" style="width:260px;">
			<div  id="div_WeeksHead" >
                 Delivery
                <br />
<label id="chkSunHead" class="weekday" style="cursor:pointer;pointer-events:none;"  onclick="chkAll(this,'chkSun')">Sun </label> &nbsp;
<label id="chkMonHead" class="weekday" style="cursor:pointer;pointer-events:none;"  onclick="chkAll(this,'chkMon')">Mon </label> &nbsp;
<label id="chkTueHead" class="weekday" style="cursor:pointer;pointer-events:none;"  onclick="chkAll(this,'chkTue')">Tue </label> &nbsp;
<label id="chkWedHead" class="weekday" style="cursor:pointer;pointer-events:none;"  onclick="chkAll(this,'chkWed')">Wed </label> &nbsp;
<label id="chkThuHead" class="weekday" style="cursor:pointer;pointer-events:none;"  onclick="chkAll(this,'chkThu')">Thu </label> &nbsp; 
<label id="chkFriHead" class="weekday" style="cursor:pointer;pointer-events:none;"  onclick="chkAll(this,'chkFri')">Fri </label> &nbsp;
<label id="chkSatHead" class="weekday" style="cursor:pointer;pointer-events:none;"  onclick="chkAll(this,'chkSat')">Sat </label> &nbsp;
</div>
			</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 80px;">Reporting cutoff
                     <input type="text" style="width:80px;" name="Reportingcutoff" onblur="showme(this)"  class="Reportingcutoff timepiker" value="6:30pm"  />
                </th> 
                <th class="GridViewHeaderStyle" scope="col"  style="width: 30px;">
                    <input id="chkheader" type="checkbox" /></th> 
            </tr>
</thead>
            <tbody>
<#}#>
       <#
            
             var dataLength=PatientData.length;
              var LastDataIndex=_PageSize+(_PageNo*_PageSize);
            

   if(LastDataIndex>dataLength)
  LastDataIndex=dataLength;

           

              window.status="Total Records Found :"+ dataLength;
              var objRow;   
         for(var j=_PageNo*_PageSize;j<LastDataIndex;j++)
        {

        objRow = PatientData[j];
         
            #>
                    <tr id="<#=objRow.SubCategoryID#>|<#=objRow.Type_ID#>|<#=objRow.CentreId#>|<#=objRow.ID#>" >
<td class="GridViewLabItemStyle" style="background-color:lightgoldenrodyellow;"><#=j+1#></td>
                        <td  class="GridViewLabItemStyle" style="background-color:lightgoldenrodyellow;">
                              <#=objRow.InvName#>
                            </td>
                         <td  class="GridViewLabItemStyle" style="background-color:lightgoldenrodyellow;">
                              <#=objRow.testcode#>
                            </td>
                      
<td  class="GridViewLabItemStyle" style="background-color:lightgoldenrodyellow;text-align:center;">
    <input type="text" style="width:80px;" name="bookingcutoff" class="bookingcutoff timepiker"  value="<#=objRow.bookingcutoff#>"  />
</td>   
<td  class="GridViewLabItemStyle" style="background-color:lightgoldenrodyellow; text-align:center;">
    <input type="text" style="width:80px;" name="sracutoff" class="sracutoff timepiker"  value="<#=objRow.sracutoff#>"  />
</td>
                        <td id="Td1" class="GridViewLabItemStyle" Style="width:290px;background-color:lightgoldenrodyellow;text-align:center;">
<div  id="div_Weeks_Proc">
<span id="chkSun_Proc"  flag="<#=objRow.Sun_Proc#>" style="cursor:pointer;" class="<#=objRow.Sun_Proc.replace('1','GridViewDragItemStyle')#>">Sun </span> &nbsp;
<span id="chkMon_Proc"  flag="<#=objRow.Mon_Proc#>" style="cursor:pointer;"  class="<#=objRow.Mon_Proc.replace('1','GridViewDragItemStyle')#>">Mon </span> &nbsp;
<span id="chkTue_Proc"  flag="<#=objRow.Tue_Proc#>" style="cursor:pointer;"  class="<#=objRow.Tue_Proc.replace('1','GridViewDragItemStyle')#>">Tue </span> &nbsp;
<span id="chkWed_Proc"  flag="<#=objRow.Wed_Proc#>" style="cursor:pointer;"  class="<#=objRow.Wed_Proc.replace('1','GridViewDragItemStyle')#>">Wed </span> &nbsp;
<span id="chkThu_Proc"  flag="<#=objRow.Thu_Proc#>" style="cursor:pointer;"  class="<#=objRow.Thu_Proc.replace('1','GridViewDragItemStyle')#>">Thu </span> &nbsp; 
<span id="chkFri_Proc"  flag="<#=objRow.Fri_Proc#>" style="cursor:pointer;"  class="<#=objRow.Fri_Proc.replace('1','GridViewDragItemStyle')#>">Fri </span> &nbsp;
<span id="chkSat_Proc"  flag="<#=objRow.Sat_Proc#>" style="cursor:pointer;"  class="<#=objRow.Sat_Proc.replace('1','GridViewDragItemStyle')#>">Sat </span> &nbsp;
</div>
</td>
  <td class="GridViewLabItemStyle" style="background-color:lightgoldenrodyellow; text-align:left;">
 <#if(objRow.DayType=="Day"){#>
   <select class="DayType" onchange="Change(this)">
       <option value="Day" selected>Day</option>
       <option value="WeekDay">Week Day</option>
   </select>     
      <#}else if(objRow.DayType=="WeekDay"){#>
   <select class="DayType" onchange="Change(this)">
       <option value="Day" >Day</option>
       <option value="WeekDay" selected>Week Day</option>
   </select>
      <#}else{#>
   <select class="DayType" onchange="Change(this)">
       <option value="Day" >Day</option>
       <option value="WeekDay">Week Day</option>
   </select>
      <#}#> 
</td>
<td  class="GridViewLabItemStyle" style="background-color:lightgoldenrodyellow;text-align:center;">     
    <input type="text" <#=objRow.DayType=="WeekDay"?'disabled':''#> style="width:80px;" name="testprocessingday" class="testprocessingday" value="<#=objRow.testprocessingday#>"  onkeyup="nmrcOnly(this)"  />
</td>
<td id="DayType1" class="GridViewLabItemStyle" Style="width:290px;background-color:lightgoldenrodyellow;text-align:center;">
<div  id="div_Weeks">
<span id="chkSun"  flag="<#=objRow.Sun#>" style="cursor:pointer;" class="weekday <#=objRow.Sun.replace('1','GridViewDragItemStyle')#> <#=objRow.DayType.replace('Day','GridViewDesableItemStyle')#> <#=objRow.DayType.replace('','GridViewDesableItemStyle')#>" >Sun </span> &nbsp;
<span id="chkMon"  flag="<#=objRow.Mon#>" style="cursor:pointer;" class="weekday <#=objRow.Mon.replace('1','GridViewDragItemStyle')#> <#=objRow.DayType.replace('Day','GridViewDesableItemStyle')#> <#=objRow.DayType.replace('','GridViewDesableItemStyle')#>" >Mon </span> &nbsp;
<span id="chkTue"  flag="<#=objRow.Tue#>" style="cursor:pointer;" class="weekday <#=objRow.Tue.replace('1','GridViewDragItemStyle')#> <#=objRow.DayType.replace('Day','GridViewDesableItemStyle')#> <#=objRow.DayType.replace('','GridViewDesableItemStyle')#>" >Tue </span> &nbsp;
<span id="chkWed"  flag="<#=objRow.Wed#>" style="cursor:pointer;" class="weekday <#=objRow.Wed.replace('1','GridViewDragItemStyle')#> <#=objRow.DayType.replace('Day','GridViewDesableItemStyle')#> <#=objRow.DayType.replace('','GridViewDesableItemStyle')#>" >Wed </span> &nbsp;
<span id="chkThu"  flag="<#=objRow.Thu#>" style="cursor:pointer;" class="weekday <#=objRow.Thu.replace('1','GridViewDragItemStyle')#> <#=objRow.DayType.replace('Day','GridViewDesableItemStyle')#> <#=objRow.DayType.replace('','GridViewDesableItemStyle')#>" >Thu </span> &nbsp; 
<span id="chkFri"  flag="<#=objRow.Fri#>" style="cursor:pointer;" class="weekday <#=objRow.Fri.replace('1','GridViewDragItemStyle')#> <#=objRow.DayType.replace('Day','GridViewDesableItemStyle')#> <#=objRow.DayType.replace('','GridViewDesableItemStyle')#>" >Fri </span> &nbsp;
<span id="chkSat"  flag="<#=objRow.Sat#>" style="cursor:pointer;" class="weekday <#=objRow.Sat.replace('1','GridViewDragItemStyle')#> <#=objRow.DayType.replace('Day','GridViewDesableItemStyle')#> <#=objRow.DayType.replace('','GridViewDesableItemStyle')#>" >Sat </span> &nbsp;
</div>
</td>
<td  class="GridViewLabItemStyle" style="background-color:lightgoldenrodyellow;text-align:center;">
    <input type="text" style="width:80px;" name="Reportingcutoff" class="Reportingcutoff timepiker"  value="<#=objRow.reportingcutoff#>" />
</td>                          
<td class="GridViewLabItemStyle" style="width:10px;background-color:lightgoldenrodyellow;">
    <input id="chk" type="checkbox" />
</td>
</tr>
            <#}#>

   
    <#if(_PageNo==0){#>
                </tbody>
     </table> 
            
           <#}
           
           _PageNo++;
          
           #>
       
    </script>
    
   
     <script type="text/javascript">

         function Func() {
             $("#tb_grdLabSearch tr").find("span").click(function () {
                 if ($(this).hasClass("GridViewDragItemStyle")) {
                     $(this).removeClass("GridViewDragItemStyle");
                     $(this).attr("flag", "0");
                 }
                 else {
                     $(this).addClass("GridViewDragItemStyle");
                     $(this).attr("flag", "1");
                 }

             });
         }
         function createdatatodave() {
             var daattosave = new Array();

             $('#tb_grdLabSearch tbody tr').each(function () {
                 var row = this;
                 var id = $(row).attr("id");

                 if ($(row).find("#chk").is(':checked')) {
                     var objPLO = new Object();
                     objPLO.CentreID = id.split('|')[2];
                     objPLO.ID = id.split('|')[3];
                     objPLO.bookingcutoff = $(row).find(".bookingcutoff").val();
                     objPLO.sracutoff = $(row).find(".sracutoff").val();
                     objPLO.testprocessingday = $(row).find(".testprocessingday").val();
                     objPLO.Reportingcutoff = $(row).find(".Reportingcutoff").val();
                     objPLO.SubcategoryID = id.split('|')[0];
                     objPLO.Investigation_ID = id.split('|')[1];
                     objPLO.Sun = $(row).find("#chkSun").attr("flag");
                     objPLO.Mon = $(row).find("#chkMon").attr("flag");
                     objPLO.Tue = $(row).find("#chkTue").attr("flag");
                     objPLO.Wed = $(row).find("#chkWed").attr("flag");
                     objPLO.Thu = $(row).find("#chkThu").attr("flag");
                     objPLO.Fri = $(row).find("#chkFri").attr("flag");
                     objPLO.Sat = $(row).find("#chkSat").attr("flag");

                     objPLO.Sun_Proc = $(row).find("#chkSun_Proc").attr("flag");
                     objPLO.Mon_Proc = $(row).find("#chkMon_Proc").attr("flag");
                     objPLO.Tue_Proc = $(row).find("#chkTue_Proc").attr("flag");
                     objPLO.Wed_Proc = $(row).find("#chkWed_Proc").attr("flag");
                     objPLO.Thu_Proc = $(row).find("#chkThu_Proc").attr("flag");
                     objPLO.Fri_Proc = $(row).find("#chkFri_Proc").attr("flag");
                     objPLO.Sat_Proc = $(row).find("#chkSat_Proc").attr("flag");
                     objPLO.DayType = $(row).find(".DayType").val();
                     daattosave.push(objPLO);
                 }

             });
             return daattosave;
         }

         function save() {
             $("#btnSave").attr('disabled', true);

             var objsavedata = createdatatodave();

             if (objsavedata == "") {
                // showerrormsg("Kindly select an Investigation ");
                 modelAlert('Kindly select an Investigation ');
                 $("#btnSave").attr('disabled', false);
                 return;
             }

             $.ajax({

                 url: "ManageDeliveryDays.aspx/SaveInvDeliveryDays",
                 data: JSON.stringify({ objsavedata: objsavedata }),
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {
                     if (result.d == "1") {
                         $("#tb_grdLabSearch tr").remove();
                         modelAlert('');
                         modelAlert('Record Saved Successfully', function () {
                             Search();
                         });
                        // showmsg("Record Saved Successfully");
                        
                     }
                     else {
                         modelAlert('Record Not Saved');
                        // showerrormsg("Record Not Saved");
                     }

                     $("#btnSave").attr('disabled', false);
                 },
                 error: function (xhr, status) {
                    // showerrormsg("Error has occured Record Not saved ");
                     modelAlert('Error has occured Record Not saved ');
                     $("#btnSave").attr('disabled', false);
                     window.status = status + "\r\n" + xhr.responseText;
                 }
             });
         }


         function chkAll(ctrl, chk) {
             if ($(ctrl).hasClass("GridViewDragItemStyle")) {
                 $(ctrl).removeClass("GridViewDragItemStyle");
                 $("#tb_grdLabSearch tr").find("#" + chk).attr("flag", "0").removeClass("GridViewDragItemStyle");
             }
             else {
                 $(ctrl).addClass("GridViewDragItemStyle");
                 $("#tb_grdLabSearch tr").find("#" + chk).attr("flag", "1").addClass("GridViewDragItemStyle");
             }


         };
         function ChangeDays(ctr) {
             $('.DayType').val($(ctr).val());
             if ($(ctr).val() == "WeekDay") {
                 $('.testprocessingday').attr('disabled', 'disabled');
                 $(".weekday").css("pointer-events", "auto");
                 $(".weekday").removeClass("GridViewDesableItemStyle");
             }
             else {
                 $('.testprocessingday').removeAttr('disabled');
                 $(".weekday").css("pointer-events", "none");
                 $(".weekday").addClass("GridViewDesableItemStyle");
             }
         }
         function Change(ctr) {       
             if ($(ctr).val() == "WeekDay") {
                 $(ctr).closest("tr").find('.testprocessingday').attr('disabled', 'disabled');
                 $(ctr).closest("tr").find(".weekday").css("pointer-events", "auto");
                 $(ctr).closest("tr").find(".weekday").removeClass("GridViewDesableItemStyle");
             }
             else {
                 $(ctr).closest("tr").find('.testprocessingday').removeAttr('disabled');
                 $(ctr).closest("tr").find(".weekday").css("pointer-events", "none");
                 $(ctr).closest("tr").find(".weekday").addClass("GridViewDesableItemStyle");
             }
         }
         function showmsg(msg) {
             $('#msgField').html('');
             $('#msgField').append(msg);
             $(".alert").css('background-color', '#04b076');
             $(".alert").removeClass("in").show();
             $(".alert").delay(1500).addClass("in").fadeOut(1000);
         }
         function showerrormsg(msg) {
             $('#msgField').html('');
             $('#msgField').append(msg);
             $(".alert").css('background-color', 'red');
             $(".alert").removeClass("in").show();
             $(".alert").delay(1500).addClass("in").fadeOut(1000);
         }

 </script>
    <style>
        .GridViewDesableItemStyle {
    border: solid 1px transparent!important;
  pointer-events:none !important;
    background-color: transparent !important;
}
        .GridViewDesableItemStyle {
    border: solid 1px transparent!important;
    pointer-events:none !important;
    background-color: transparent !important;
}
.GridViewDragItemStyle
{ 
	border:solid 1px #C6DFF9;padding-left:5px;font-size:9pt;background-color:#BCEE68;
}
    </style>
</asp:Content>

