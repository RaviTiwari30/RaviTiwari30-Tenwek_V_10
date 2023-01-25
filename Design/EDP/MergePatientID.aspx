<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="MergePatientID.aspx.cs" Inherits="Design_EDP_MergePatientID" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <script type="text/javascript" src="../../Scripts/Search.js"> </script>
     <script src="../../Scripts/jquery.extensions.js" type="text/javascript"></script>
    <script  src="../../Scripts/json2.js" type="text/javascript"></script>
   <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Merge Duplicate Patient Medical Record</b>&nbsp;<br />
            <span id="spnErrorMsg" class="ItDoseLblError"></span>
        </div>
        <div class="POuter_Box_Inventory">
           <div class="row">
               <div class="col-md-1"></div>
               <div class="col-md-22">
                   <div class="row">
                       <div class="col-md-3">
                            <label class="pull-left">
                            Source Patient ID
                        </label>
                        <b class="pull-right">:</b>
                       </div>
                       <div class="col-md-5">
                           <input type="text" autocomplete="off" style="border-bottom-color: red; border-bottom-width: 2px"  id="txtSourceUHID" style="text-transform: uppercase" maxlength="50" title="Enter Source UHID " />
                       </div>
                       <div class="col-md-3"></div>
                         <div class="col-md-4">
                            <label class="pull-left">
                            Destination Patient ID
                        </label>
                        <b class="pull-right">:</b>
                       </div>
                       <div class="col-md-5">
                           <input type="text" autocomplete="off" style="border-bottom-color: red; border-bottom-width: 2px" maxlength="50" id="txtDestUHID" style="text-transform: uppercase" title="Enter Destination UHID " />
                       </div>
                       <div class="col-md-2"></div>
                       <div class="col-md-3">
                           <input type="button" title="Click to Search Patient Detail" id="btnSearch" value="Search" class="ItDoseButton" onclick="BindPatientDetail();" />
                       </div>
                   </div>
               </div>
               <div class="col-md-1"></div>
           </div>
        </div>
         <div class="POuter_Box_Inventory" style="text-align: center">
         <div id="PatientOutput" style="max-height: 500px; overflow-x: auto;"></div>
             </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <input type="button" id="btnSave" value="MAP" tabindex="5" class="ItDoseButton" onclick="MapUHID();" style="display:none;" />
        </div>
    </div>
  <script type="text/javascript">
      function BindPatientDetail()
      {

          if ($.trim($('#txtSourceUHID').val()) == "") {
              modelAlert("Please Enter Source UHID");
              $('#txtSourceUHID').focus();
              return false;
          }
          if ($.trim($('#txtDestUHID').val()) == "") {
                  modelAlert("Please Enter Destination UHID");
                  $('#txtDestUHID').focus();
                  return false;
              }
          if ($.trim($('#txtSourceUHID').val()) == $.trim($('#txtDestUHID').val()))
          {
              modelAlert("Source UHID and Destination ID can not be same...!!!");
              $('#txtDestUHID').focus();
              return false;
          }

              $.ajax({
                  url: "MergePatientID.aspx/bindPatientDetail",
                  data: '{DestPatientID:"' + $('#txtDestUHID').val() + '",SourcePatientID:"' + $('#txtSourceUHID').val() + '"}',
                  type: "POST",
                  contentType: "application/json; charset=utf-8",
                  timeout: 120000,
                  async: true,
                  dataType: "json",
                  success: function (result) {
                      if (result.d != "") {
                          PatientData = jQuery.parseJSON(result.d);
                          if (PatientData != null) {
                              var output = $('#tb_PatientSearch').parseTemplate(PatientData);
                              $('#PatientOutput').html(output);
                              $('#PatientOutput').show();
                              $('#btnSave').show();
                          }
                      }
                      else {
                          $('#PatientOutput').html();
                          $('#PatientOutput').hide();
                          $('#btnSave').hide();
                          modelAlert('No Record Found');
                      }
                  },
                  error: function (xhr, status) {
                      window.status = status + "\r\n" + xhr.responseText;
                      $('#PatientOutput').html();
                      $('#PatientOutput').hide();
                      modelAlert('Error');
                  }
              });
      }

      function MapUHID() {
          var SourceUHID = "";
          var DestUHID = "";
          $("#tb_grdPatientSearch tr").each(function () {
              var id = $(this).attr("id");
              var $rowid = $(this).closest("tr");
              if (id != "Header") {
                  if ($.trim($rowid.find("#tdPatientType").text()) == "Source Patient")
                      SourceUHID = $.trim($rowid.find("#tdUHID").text());
                  else
                      DestUHID = $.trim($rowid.find("#tdUHID").text());
                }
          });
          if (SourceUHID == "")
          {
              modelAlert('Source UHID does not Exist');
              return;
          }
          else if (DestUHID == "") {
              modelAlert('Destination UHID does not Exist');
              return;
          }
          else {
              $.ajax({
                  url: "MergePatientID.aspx/MapUHID",
                  data: '{SourceUHID:"' + SourceUHID + '",DestUHID:"' + DestUHID + '"}',
                  type: "POST",
                  contentType: "application/json; charset=utf-8",
                  timeout: 120000,
                  async: false,
                  dataType: "json",
                  cache: false,
                  success: function (result) {
                      if (result.d == "0") {
                          modelAlert("Record Not Saved");
                      }
                      else {
                          modelAlert('Record Saved Successfully');
                          $('#PatientOutput').hide();
                          $('#txtSourceUHID').val('');
                          $('#txtDestUHID').val('');
                          $('#btnSave').hide();
                      }
                  },
                  error: function (xhr, status) {
                      modelAlert("Error");
                  }
              });
          }
      }
  </script>
     <script id="tb_PatientSearch" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdPatientSearch"
    style="width:100%;border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;">PatientType</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;">Patient ID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Patient Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;">Age/Sex</th>        
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Contact No</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Address</th>
            
		</tr>

        <#       
        var dataLength=PatientData.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;     
        for(var j=0;j<dataLength;j++)
        {       
        objRow = PatientData[j];
        #>
                    <tr id="<#=j+1#>"     
                                    <#if(objRow.PatientType=="Source Patient"){#>
					                style="background-color:#FF99CC"
				                    <#}else{#>
					                    style="background-color:#90EE90"
				                    <#}#>
                                    >                       
                        <td class="GridViewLabItemStyle"><#=j+1#></td>
                        <td class="GridViewLabItemStyle" id="tdPatientType"><#=objRow.PatientType#></td>
                        <td class="GridViewLabItemStyle" id="tdUHID"><#=objRow.Patient_ID#></td>
                        <td class="GridViewLabItemStyle"><#=objRow.Pname#></td>
                        <td class="GridViewLabItemStyle"><#=objRow.AgeSex#></td>
                        <td class="GridViewLabItemStyle"><#=objRow.Mobile#></td>
                        <td class="GridViewLabItemStyle"><#=objRow.Address#></td>
                    </tr>           
        <#}#>                     
     </table>    
    </script>
</asp:Content>

